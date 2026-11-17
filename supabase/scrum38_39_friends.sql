-- =====================================================================
-- SCRUM-38 (add friend: request / accept) + SCRUM-39 (remove friend)
-- Run once in Supabase -> SQL Editor. Safe to run again.
-- Does NOT change any existing table, so it can't break teammates' code.
-- =====================================================================

-- 1) friend_profiles: searchable usernames for the friends feature
--    (separate from the team's existing "profiles" table, which we do not touch)
create table if not exists public.friend_profiles (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  username   text not null,
  updated_at timestamptz not null default now()
);

-- No two players can have the same username (ignoring upper/lower case)
create unique index if not exists friend_profiles_username_unique
  on public.friend_profiles (upper(username));

alter table public.friend_profiles enable row level security;
-- No policies on purpose: the game only reaches this table through the functions below.

-- 2) friendships: one row per pair of players
--    'pending' = asked, not answered yet / 'accepted' = friends
--    (declined / removed rows are simply deleted)
create table if not exists public.friendships (
  id         bigint generated always as identity primary key,
  requester  uuid not null references auth.users (id) on delete cascade,
  addressee  uuid not null references auth.users (id) on delete cascade,
  status     text not null default 'pending' check (status in ('pending', 'accepted')),
  created_at timestamptz not null default now(),
  check (requester <> addressee)
);

-- Only one row per pair, whichever direction the request went
create unique index if not exists friendships_pair_unique
  on public.friendships (least(requester, addressee), greatest(requester, addressee));

alter table public.friendships enable row level security;

-- 3) Helper (private): my username, or the part of my email before the @
create or replace function private.friends_profile_name(p_user uuid)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select left(trim(coalesce(
           nullif(trim(u.raw_user_meta_data ->> 'username'), ''),
           split_part(u.email, '@', 1)
         )), 20)
  from auth.users u
  where u.id = p_user;
$$;

-- 4) friends_sync_profile(): copy my current username into friend_profiles
--    Returns { status: "ok" | "taken", username }
create or replace function public.friends_sync_profile()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me   uuid := auth.uid();
  v_name text;
begin
  if v_me is null then
    raise exception 'not logged in';
  end if;

  v_name := private.friends_profile_name(v_me);

  if exists (select 1 from public.friend_profiles
             where upper(username) = upper(v_name) and user_id <> v_me) then
    return jsonb_build_object('status', 'taken', 'username', v_name);
  end if;

  insert into public.friend_profiles (user_id, username, updated_at)
  values (v_me, v_name, now())
  on conflict (user_id) do update
    set username = excluded.username, updated_at = now();

  return jsonb_build_object('status', 'ok', 'username', v_name);
end;
$$;

-- 5) send_friend_request(username)   (SCRUM-38)
--    status: sent | accepted | not_found | self | already_friends | already_sent
create or replace function public.send_friend_request(p_username text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me     uuid := auth.uid();
  v_target uuid;
  v_row    public.friendships%rowtype;
begin
  if v_me is null then
    raise exception 'not logged in';
  end if;

  select user_id into v_target
  from public.friend_profiles
  where upper(username) = upper(trim(p_username));

  if v_target is null then
    return jsonb_build_object('status', 'not_found');
  end if;
  if v_target = v_me then
    return jsonb_build_object('status', 'self');
  end if;

  select * into v_row
  from public.friendships
  where least(requester, addressee)    = least(v_me, v_target)
    and greatest(requester, addressee) = greatest(v_me, v_target);

  if found then
    if v_row.status = 'accepted' then
      return jsonb_build_object('status', 'already_friends');
    elsif v_row.requester = v_me then
      return jsonb_build_object('status', 'already_sent');
    else
      update public.friendships set status = 'accepted' where id = v_row.id;
      return jsonb_build_object('status', 'accepted');
    end if;
  end if;

  insert into public.friendships (requester, addressee) values (v_me, v_target);
  return jsonb_build_object('status', 'sent');
end;
$$;

-- 6) respond_friend_request(id, accept)   (SCRUM-38)
--    Only the player who RECEIVED the request can answer.
--    status: accepted | declined | not_found
create or replace function public.respond_friend_request(p_id bigint, p_accept boolean)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
begin
  if v_me is null then
    raise exception 'not logged in';
  end if;

  if p_accept then
    update public.friendships set status = 'accepted'
    where id = p_id and addressee = v_me and status = 'pending';
    if found then return jsonb_build_object('status', 'accepted'); end if;
  else
    delete from public.friendships
    where id = p_id and addressee = v_me and status = 'pending';
    if found then return jsonb_build_object('status', 'declined'); end if;
  end if;

  return jsonb_build_object('status', 'not_found');
end;
$$;

-- 7) remove_friend(id)   (SCRUM-39)
--    Removes a friend, or cancels a request you sent.
--    status: removed | not_found
create or replace function public.remove_friend(p_id bigint)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
begin
  if v_me is null then
    raise exception 'not logged in';
  end if;

  delete from public.friendships
  where id = p_id and (requester = v_me or addressee = v_me);

  if found then
    return jsonb_build_object('status', 'removed');
  end if;
  return jsonb_build_object('status', 'not_found');
end;
$$;

-- 8) get_friends(): everything the friends panel needs
--    friends  = [{ id, name, xp }]  <- same shape as Dylan L's panel
--    incoming = [{ id, name }]      requests waiting for MY answer
--    outgoing = [{ id, name }]      requests I sent
create or replace function public.get_friends()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
begin
  if v_me is null then
    raise exception 'not logged in';
  end if;

  return jsonb_build_object(
    'friends', coalesce((
      select jsonb_agg(jsonb_build_object(
               'id',   f.id,
               'name', coalesce(p.username, '???'),
               'xp',   coalesce(pp.xp, 0))
             order by upper(coalesce(p.username, '')))
      from public.friendships f
      left join public.friend_profiles p
             on p.user_id = case when f.requester = v_me then f.addressee else f.requester end
      left join public.player_progress pp
             on pp.user_id = case when f.requester = v_me then f.addressee else f.requester end
      where f.status = 'accepted' and (f.requester = v_me or f.addressee = v_me)
    ), '[]'::jsonb),

    'incoming', coalesce((
      select jsonb_agg(jsonb_build_object('id', f.id, 'name', coalesce(p.username, '???'))
             order by f.created_at)
      from public.friendships f
      left join public.friend_profiles p on p.user_id = f.requester
      where f.status = 'pending' and f.addressee = v_me
    ), '[]'::jsonb),

    'outgoing', coalesce((
      select jsonb_agg(jsonb_build_object('id', f.id, 'name', coalesce(p.username, '???'))
             order by f.created_at)
      from public.friendships f
      left join public.friend_profiles p on p.user_id = f.addressee
      where f.status = 'pending' and f.requester = v_me
    ), '[]'::jsonb)
  );
end;
$$;

-- 9) Who may call what: only logged-in players, only the 5 public functions
revoke all on function private.friends_profile_name(uuid) from public, anon, authenticated;

revoke all on function public.friends_sync_profile()                  from public, anon;
revoke all on function public.send_friend_request(text)               from public, anon;
revoke all on function public.respond_friend_request(bigint, boolean) from public, anon;
revoke all on function public.remove_friend(bigint)                   from public, anon;
revoke all on function public.get_friends()                           from public, anon;

grant execute on function public.friends_sync_profile()                  to authenticated;
grant execute on function public.send_friend_request(text)               to authenticated;
grant execute on function public.respond_friend_request(bigint, boolean) to authenticated;
grant execute on function public.remove_friend(bigint)                   to authenticated;
grant execute on function public.get_friends()                           to authenticated;