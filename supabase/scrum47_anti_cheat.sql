-- =========================================================
-- SCRUM-47 (1 of 2): tables + server functions
-- Safe to run now: nothing is locked yet, the current game keeps working.
-- =========================================================

-- 0) Make sure the xp column (Dylan H's XP feature) exists and has a default
alter table public.player_progress add column if not exists xp integer not null default 0;
alter table public.player_progress alter column xp set default 0;

-- 1) Real price list: players can read it, only the team can change it
create table if not exists public.shop_items (
  name  text primary key,
  price integer not null check (price >= 0)
);
insert into public.shop_items (name, price) values
  ('ROBOT', 20), ('NINJA', 40), ('WIZARD', 60),
  ('DARK', 30), ('RETRO', 50), ('OCEAN', 50),
  ('HINT PACK', 10), ('XP BOOST', 40), ('SHIELD', 60)
on conflict (name) do update set price = excluded.price;

alter table public.shop_items enable row level security;
drop policy if exists "anyone logged in can read prices" on public.shop_items;
create policy "anyone logged in can read prices"
  on public.shop_items for select to authenticated using (true);

-- 2) Coin log: every reward (+) and purchase (-)
create table if not exists public.coin_ledger (
  id         bigint generated always as identity primary key,
  user_id    uuid not null references auth.users (id) on delete cascade,
  amount     integer not null,
  reason     text not null,
  created_at timestamptz not null default now()
);
create index if not exists coin_ledger_user_time on public.coin_ledger (user_id, created_at);
alter table public.coin_ledger enable row level security;
drop policy if exists "read own coin log" on public.coin_ledger;
create policy "read own coin log"
  on public.coin_ledger for select to authenticated using (auth.uid() = user_id);

-- 3) Cheat log: only the team sees it (dashboard). No policies on purpose.
create table if not exists public.cheat_flags (
  id         bigint generated always as identity primary key,
  user_id    uuid not null references auth.users (id) on delete cascade,
  reason     text not null,
  details    text,
  created_at timestamptz not null default now()
);
alter table public.cheat_flags enable row level security;

-- 4) Private helpers (the game can't call these directly)
create schema if not exists private;

-- The player's name for the pop-up: username, Google name, or start of email
create or replace function private.current_username()
returns text language sql stable set search_path = '' as $$
  select upper(left(coalesce(
    nullif(auth.jwt() -> 'user_metadata' ->> 'username', ''),
    nullif(auth.jwt() -> 'user_metadata' ->> 'full_name', ''),
    nullif(auth.jwt() -> 'user_metadata' ->> 'name', ''),
    nullif(split_part(auth.jwt() ->> 'email', '@', 1), ''),
    'PLAYER'), 12));
$$;

-- Records a cheat attempt and returns the "cheat" answer for the pop-up
create or replace function private.flag_cheat(p_user uuid, p_reason text, p_details text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v_attempt int; v_coins int; v_xp int; v_owned text[];
begin
  insert into public.cheat_flags (user_id, reason, details)
  values (p_user, left(p_reason, 50), left(p_details, 200));
  select count(*) into v_attempt from public.cheat_flags where user_id = p_user;
  select coins, xp, owned into v_coins, v_xp, v_owned
    from public.player_progress where user_id = p_user;
  return jsonb_build_object('status', 'cheat', 'attempt', v_attempt,
    'username', private.current_username(),
    'coins', coalesce(v_coins, 0), 'xp', coalesce(v_xp, 0),
    'owned', to_jsonb(coalesce(v_owned, '{}'::text[])));
end; $$;

revoke all on function private.current_username() from public, anon, authenticated;
revoke all on function private.flag_cheat(uuid, text, text) from public, anon, authenticated;

-- 5) BUY: the server looks up the real price and does the purchase
create or replace function public.buy_item(p_item text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_user uuid := auth.uid();
  v_price int; v_coins int; v_xp int; v_owned text[];
begin
  if v_user is null then raise exception 'not logged in'; end if;

  insert into public.player_progress (user_id) values (v_user) on conflict (user_id) do nothing;
  select coins, xp, owned into v_coins, v_xp, v_owned
    from public.player_progress where user_id = v_user for update;

  select price into v_price from public.shop_items where name = p_item;
  if v_price is null then                                  -- item isn't in the shop at all
    return private.flag_cheat(v_user, 'unknown_item', p_item);
  end if;

  if p_item = any (v_owned) then
    return jsonb_build_object('status', 'owned', 'coins', v_coins, 'xp', v_xp, 'owned', to_jsonb(v_owned));
  end if;
  if v_coins < v_price then
    return jsonb_build_object('status', 'poor', 'coins', v_coins, 'xp', v_xp, 'owned', to_jsonb(v_owned));
  end if;

  update public.player_progress
     set coins = coins - v_price, owned = array_append(owned, p_item)
   where user_id = v_user
   returning coins, owned into v_coins, v_owned;
  insert into public.coin_ledger (user_id, amount, reason) values (v_user, -v_price, 'buy:' || p_item);

  return jsonb_build_object('status', 'bought', 'coins', v_coins, 'xp', v_xp, 'owned', to_jsonb(v_owned));
end; $$;

-- 6) EARN: the server adds coins + XP, within the limits
create or replace function public.earn_coins(p_amount int)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  -- ===== Limits: change these numbers to tune the rules =====
  c_max_per_request constant int := 100;   -- most coins one lesson visit can give
  c_max_per_day     constant int := 300;   -- most coins per 24 hours
  c_suspicious      constant int := 500;   -- more than this in one request = cheat attempt
  -- ==========================================================
  v_user uuid := auth.uid();
  v_today int; v_grant int; v_coins int; v_xp int; v_owned text[];
begin
  if v_user is null then raise exception 'not logged in'; end if;
  insert into public.player_progress (user_id) values (v_user) on conflict (user_id) do nothing;

  if p_amount is null or p_amount < 0 or p_amount > c_suspicious then
    return private.flag_cheat(v_user, 'impossible_reward', coalesce(p_amount::text, 'null'));
  end if;

  select coalesce(sum(amount), 0) into v_today
    from public.coin_ledger
   where user_id = v_user and amount > 0 and created_at > now() - interval '24 hours';

  v_grant := least(p_amount, c_max_per_request, greatest(0, c_max_per_day - v_today));

  if v_grant > 0 then
    update public.player_progress
       set coins = coins + v_grant, xp = coalesce(xp, 0) + v_grant
     where user_id = v_user;
    insert into public.coin_ledger (user_id, amount, reason) values (v_user, v_grant, 'earn');
  end if;

  select coins, xp, owned into v_coins, v_xp, v_owned
    from public.player_progress where user_id = v_user;
  return jsonb_build_object(
    'status', case when v_grant < p_amount then 'limited' else 'ok' end,
    'granted', v_grant, 'coins', v_coins, 'xp', v_xp, 'owned', to_jsonb(v_owned));
end; $$;

-- 7) REPORT: the game reports a cheat it noticed itself (e.g. edited coins in memory)
create or replace function public.report_cheat(p_reason text, p_details text default null)
returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  if auth.uid() is null then raise exception 'not logged in'; end if;
  insert into public.player_progress (user_id) values (auth.uid()) on conflict (user_id) do nothing;
  return private.flag_cheat(auth.uid(), coalesce(p_reason, 'client_report'), p_details);
end; $$;

-- 8) Only logged-in players may call the three public functions
revoke all on function public.buy_item(text)            from public, anon;
revoke all on function public.earn_coins(int)           from public, anon;
revoke all on function public.report_cheat(text, text)  from public, anon;
grant execute on function public.buy_item(text)           to authenticated;
grant execute on function public.earn_coins(int)          to authenticated;
grant execute on function public.report_cheat(text, text) to authenticated;