-- SCRUM-29: each player's shop wallet and owned items (one row per player)
create table if not exists public.player_progress (
  user_id uuid primary key
          default auth.uid()
          references auth.users (id) on delete cascade,
  coins   integer not null default 0 check (coins >= 0),
  owned   text[]  not null default '{}'
);

-- Row Level Security: each player can only see and change their own row
alter table public.player_progress enable row level security;

create policy "read own progress"
  on public.player_progress for select
  using (auth.uid() = user_id);

create policy "create own progress"
  on public.player_progress for insert
  with check (auth.uid() = user_id);

create policy "update own progress"
  on public.player_progress for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);