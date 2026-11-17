-- SCRUM-44: return earned achievements for the currently signed-in player.
-- The game calls this RPC when the Profile > Badges submenu opens.

create or replace function public.get_my_achievements()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', a.id,
        'name', a.name,
        'description', a.description,
        'badge_key', a.badge_key,
        'earned_at', ua.earned_at
      ) order by ua.earned_at desc, a.name asc
    ),
    '[]'::jsonb
  )
  from public.user_achievements as ua
  join public.achievements as a on a.id = ua.achievement_id
  where ua.user_id = auth.uid();
$$;

revoke all on function public.get_my_achievements() from public, anon, authenticated;
grant execute on function public.get_my_achievements() to authenticated;
