-- SCRUM-59: persist daily lesson streaks per Supabase user.
-- Streak days use the UTC calendar date so all devices agree on day boundaries.

alter table public.profiles
  add column if not exists streak_last_completed_on date;

create or replace function public.get_streak_status()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_today date := (now() at time zone 'UTC')::date;
  v_streak integer;
  v_last_completed date;
  v_streak_lost boolean := false;
begin
  if v_user is null then
    raise exception 'not logged in';
  end if;

  -- The signup trigger normally creates this row; keep this RPC resilient for
  -- accounts that existed before that trigger was installed.
  insert into public.profiles (id, username)
  select
    u.id,
    coalesce(nullif(u.raw_user_meta_data ->> 'username', ''),
             'user_' || substring(u.id::text, 1, 8))
  from auth.users as u
  where u.id = v_user
  on conflict (id) do nothing;

  select p.streak, p.streak_last_completed_on
    into v_streak, v_last_completed
  from public.profiles as p
  where p.id = v_user
  for update;

  if not found then
    raise exception 'profile not found';
  end if;

  if v_streak > 0
     and v_last_completed is not null
     and v_last_completed < v_today - 1 then
    v_streak := 0;
    v_streak_lost := true;

    update public.profiles
       set streak = 0,
           updated_at = now()
     where id = v_user;
  end if;

  return jsonb_build_object(
    'status', 'ok',
    'streak', coalesce(v_streak, 0),
    'streak_lost', v_streak_lost,
    'completed_today', coalesce(v_last_completed = v_today, false)
  );
end;
$$;

create or replace function public.record_lesson_streak()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_today date := (now() at time zone 'UTC')::date;
  v_streak integer;
  v_last_completed date;
begin
  if v_user is null then
    raise exception 'not logged in';
  end if;

  insert into public.profiles (id, username)
  select
    u.id,
    coalesce(nullif(u.raw_user_meta_data ->> 'username', ''),
             'user_' || substring(u.id::text, 1, 8))
  from auth.users as u
  where u.id = v_user
  on conflict (id) do nothing;

  select p.streak, p.streak_last_completed_on
    into v_streak, v_last_completed
  from public.profiles as p
  where p.id = v_user
  for update;

  if not found then
    raise exception 'profile not found';
  end if;

  v_streak := coalesce(v_streak, 0);

  if v_last_completed = v_today then
    -- Completing more than one level today does not add extra streak days.
    return jsonb_build_object(
      'status', 'ok',
      'streak', v_streak,
      'completed_today', true
    );
  elsif v_last_completed = v_today - 1 then
    v_streak := v_streak + 1;
  else
    v_streak := 1;
  end if;

  update public.profiles
     set streak = v_streak,
         streak_last_completed_on = v_today,
         updated_at = now()
   where id = v_user;

  return jsonb_build_object(
    'status', 'ok',
    'streak', v_streak,
    'completed_today', true
  );
end;
$$;

revoke all on function public.get_streak_status() from public, anon, authenticated;
revoke all on function public.record_lesson_streak() from public, anon, authenticated;
grant execute on function public.get_streak_status() to authenticated;
grant execute on function public.record_lesson_streak() to authenticated;
