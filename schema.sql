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
create policy "skrienam read"   on public.runs for select to anon using (true);
create policy "skrienam insert" on public.runs for insert to anon with check (true);

grant select, insert on public.runs to anon;

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

-- Delete: only the person who posted it.
create or replace function public.delete_run(run_id text, person text)
returns void language sql security definer set search_path = public as $fn$
  delete from public.runs where id = run_id and by_name = person;
$fn$;

grant execute on function public.join_run(text,text)   to anon;
grant execute on function public.leave_run(text,text)  to anon;
grant execute on function public.delete_run(text,text) to anon;

-- Optional housekeeping: past runs just stop showing in the app.
-- To actually clear them out, run this whenever you like:
--   delete from public.runs where d < current_date - 30;
