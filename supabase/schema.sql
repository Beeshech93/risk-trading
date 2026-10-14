-- Ejecuta este script en Supabase → SQL Editor.
create table if not exists public.risk_trading_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  sessions jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.risk_trading_data enable row level security;
revoke all on public.risk_trading_data from anon;
grant select, insert, update, delete on public.risk_trading_data to authenticated;
drop policy if exists "Users can read their own risk data" on public.risk_trading_data;
create policy "Users can read their own risk data" on public.risk_trading_data for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "Users can insert their own risk data" on public.risk_trading_data;
create policy "Users can insert their own risk data" on public.risk_trading_data for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "Users can update their own risk data" on public.risk_trading_data;
create policy "Users can update their own risk data" on public.risk_trading_data for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users can delete their own risk data" on public.risk_trading_data;
create policy "Users can delete their own risk data" on public.risk_trading_data for delete to authenticated using ((select auth.uid()) = user_id);
