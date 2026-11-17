   -- SCRUM-47 SQL 2: run ONLY after the SCRUM-47 PR is merged into main.
   -- After this, the game can no longer write coins/items directly.
   -- All changes must go through buy_item / earn_coins (scr_player_progress).
   drop policy if exists "create own progress" on public.player_progress;
   drop policy if exists "update own progress" on public.player_progress;