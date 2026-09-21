-- Skrienam — viena tabula, trīs funkcijas.
-- Paste this whole file into Supabase -> SQL Editor -> Run.

create table if not exists public.runs (
  id         text primary key,
  d          date         not null,
  t          time         not null,
  kur        text         not null,
  km         numeric(5,1) not null,
  p1         text         not null,
  p2         text         not null,
  by_name    text         not null,
  kas        text[]       not null default '{}',
  created_at timestamptz  not null default now()
);

create index if not exists runs_d_idx on public.runs (d, t);

alter table public.runs enable row level security;

-- Anyone with the link may read the list and post a run.
-- There is deliberately NO update/delete policy: those go through the
-- functions below, so nobody can wipe the table straight from the API.
drop policy if exists "skrienam read"   on public.runs;
drop policy if exists "skrienam insert" on public.runs;
create policy "skrienam read"   on public.runs for select to anon, authenticated using (true);
create policy "skrienam insert" on public.runs for insert to anon, authenticated with check (true);

grant select, insert on public.runs to anon, authenticated;

-- Join: append the name, never twice. Atomic at the row.
create or replace function public.join_run(run_id text, person text)
returns void language sql security definer set search_path = public as $fn$
  update public.runs
     set kas = array_append(array_remove(kas, person), person)
   where id = run_id;
$fn$;

-- Leave.
create or replace function public.leave_run(run_id text, person text)
returns void language sql security definer set search_path = public as $fn$
  update public.runs set kas = array_remove(kas, person) where id = run_id;
$fn$;

-- Edit: only the person who posted it, and the roster is deliberately
-- untouched. Fixing a typo must not cost you the people who already joined.
create or replace function public.update_run(
  run_id text, person text,
  new_d date, new_t time, new_kur text,
  new_km numeric, new_p1 text, new_p2 text)
returns void language sql security definer set search_path = public as $fn$
  update public.runs
     set d = new_d, t = new_t, kur = new_kur,
         km = new_km, p1 = new_p1, p2 = new_p2
   where id = run_id and by_name = person;
$fn$;

-- Delete: only the person who posted it.
create or replace function public.delete_run(run_id text, person text)
returns void language sql security definer set search_path = public as $fn$
  delete from public.runs where id = run_id and by_name = person;
$fn$;

grant execute on function public.join_run(text,text)   to anon, authenticated;
grant execute on function public.leave_run(text,text)  to anon, authenticated;
grant execute on function public.delete_run(text,text) to anon, authenticated;
grant execute on function public.update_run(text,text,date,time,text,numeric,text,text) to anon, authenticated;

-- Optional housekeeping: past runs just stop showing in the app.
-- To actually clear them out, run this whenever you like:
--   delete from public.runs where d < current_date - 30;
