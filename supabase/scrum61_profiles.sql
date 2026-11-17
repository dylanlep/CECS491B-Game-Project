-- SCRUM-61: extend the existing public profile table with server-owned stats.
-- Run in the Supabase SQL Editor after reviewing the project branch.

-- The project already has public.profiles (username, total_points, level, etc.).
-- Keep that table and its existing data; add the fields required by SCRUM-61.
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null,
  total_points integer not null default 0,
  level integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles
  add column if not exists xp integer not null default 0,
  add column if not exists streak integer not null default 0;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conrelid = 'public.profiles'::regclass
      and conname = 'profiles_xp_nonnegative'
  ) then
    alter table public.profiles
      add constraint profiles_xp_nonnegative check (xp >= 0);
  end if;

  if not exists (
    select 1 from pg_constraint
    where conrelid = 'public.profiles'::regclass
      and conname = 'profiles_streak_nonnegative'
  ) then
    alter table public.profiles
      add constraint profiles_streak_nonnegative check (streak >= 0);
  end if;
end;
$$;

-- Recreate profiles for existing Auth users if needed. New signups are handled
-- by the trigger below. Existing profile usernames are preserved.
insert into public.profiles (id, username)
select
  u.id,
  coalesce(nullif(u.raw_user_meta_data ->> 'username', ''),
           'user_' || substring(u.id::text, 1, 8))
from auth.users as u
on conflict (id) do nothing;

-- Use player_progress.xp as the current XP source of truth. Level follows the
-- game's existing rule: one level for every 100 XP, starting at level 1.
update public.profiles as p
set xp = pp.xp,
    level = floor(pp.xp::numeric / 100)::integer + 1,
    updated_at = now()
from public.player_progress as pp
where pp.user_id = p.id;

-- Keep the existing signup behavior and ensure each profile has a username.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'username', ''),
      'user_' || substring(new.id::text, 1, 8)
    )
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Keep profile usernames current when a player edits their Auth username.
create or replace function public.sync_profile_username_from_auth()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.profiles
  set username = coalesce(
        nullif(new.raw_user_meta_data ->> 'username', ''),
        'user_' || substring(new.id::text, 1, 8)
      ),
      updated_at = now()
  where id = new.id;

  return new;
end;
$$;

drop trigger if exists on_auth_user_metadata_updated on auth.users;
create trigger on_auth_user_metadata_updated
  after update of raw_user_meta_data on auth.users
  for each row
  when (old.raw_user_meta_data is distinct from new.raw_user_meta_data)
  execute function public.sync_profile_username_from_auth();

-- Update profile XP and level whenever trusted server-side progress writes XP.
create or replace function public.sync_profile_progress_from_player_progress()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.profiles
  set xp = new.xp,
      level = floor(new.xp::numeric / 100)::integer + 1,
      updated_at = now()
  where id = new.user_id;

  return new;
end;
$$;

drop trigger if exists sync_profile_progress on public.player_progress;
create trigger sync_profile_progress
  after insert or update of xp on public.player_progress
  for each row execute function public.sync_profile_progress_from_player_progress();

-- Clients can read their own profile, but only trusted database functions and
-- triggers can write profile statistics such as XP, level, or streak.
alter table public.profiles enable row level security;
drop policy if exists "Users can update their own profile" on public.profiles;
drop policy if exists "Users can view their own profile" on public.profiles;
create policy "Users can view their own profile"
  on public.profiles for select to authenticated
  using (auth.uid() = id);

revoke all on table public.profiles from anon, authenticated;
grant select on table public.profiles to authenticated;

-- Progress is changed through the existing SECURITY DEFINER RPCs (earn_coins,
-- buy_item). Remove direct client writes so a client cannot forge XP before
-- the profile-sync trigger runs. Keep authenticated SELECT for the game UI.
drop policy if exists "insert own progress" on public.player_progress;
drop policy if exists "create own progress" on public.player_progress;
drop policy if exists "update own progress" on public.player_progress;
drop policy if exists "Users can update their own progress" on public.player_progress;
revoke all on table public.player_progress from anon, authenticated;
grant select on table public.player_progress to authenticated;

-- Trigger functions are invoked by their triggers; clients do not need to call
-- these functions directly.
revoke all on function public.handle_new_user() from public, anon, authenticated;
revoke all on function public.sync_profile_username_from_auth() from public, anon, authenticated;
revoke all on function public.sync_profile_progress_from_player_progress() from public, anon, authenticated;
