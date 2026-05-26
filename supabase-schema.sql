-- Repair Ledger Supabase setup
-- Run this in Supabase SQL Editor after creating your project.

create extension if not exists pgcrypto;

create table if not exists public.app_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'writer' check (role in ('owner', 'writer', 'reader')),
  created_at timestamptz not null default now()
);

create table if not exists public.repair_records (
  id uuid primary key default gen_random_uuid(),
  record_type text not null check (record_type in ('repair', 'expense', 'technician')),
  record_date date not null,
  data jsonb not null,
  created_by uuid references auth.users(id),
  updated_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.app_members enable row level security;
alter table public.repair_records enable row level security;

create or replace function public.is_app_member(required_roles text[] default array['owner','writer','reader'])
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.app_members
    where user_id = auth.uid()
      and role = any(required_roles)
  );
$$;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  new.updated_by = auth.uid();
  return new;
end;
$$;

drop trigger if exists repair_records_set_updated_at on public.repair_records;
create trigger repair_records_set_updated_at
before update on public.repair_records
for each row execute function public.set_updated_at();

drop policy if exists "members can read records" on public.repair_records;
create policy "members can read records"
on public.repair_records for select
to authenticated
using (public.is_app_member());

drop policy if exists "writers can insert records" on public.repair_records;
create policy "writers can insert records"
on public.repair_records for insert
to authenticated
with check (public.is_app_member(array['owner','writer']));

drop policy if exists "writers can update records" on public.repair_records;
create policy "writers can update records"
on public.repair_records for update
to authenticated
using (public.is_app_member(array['owner','writer']))
with check (public.is_app_member(array['owner','writer']));

drop policy if exists "writers can delete records" on public.repair_records;
create policy "writers can delete records"
on public.repair_records for delete
to authenticated
using (public.is_app_member(array['owner','writer']));

drop policy if exists "owners can read members" on public.app_members;
create policy "owners can read members"
on public.app_members for select
to authenticated
using (public.is_app_member(array['owner']));

drop policy if exists "owners can manage members" on public.app_members;
create policy "owners can manage members"
on public.app_members for all
to authenticated
using (public.is_app_member(array['owner']))
with check (public.is_app_member(array['owner']));

-- After your first account signs up, run this once with that user's UUID:
-- insert into public.app_members (user_id, role)
-- values ('PASTE-YOUR-AUTH-USER-ID-HERE', 'owner')
-- on conflict (user_id) do update set role = excluded.role;

-- To give someone access later, let them sign up, then add them:
-- insert into public.app_members (user_id, role)
-- values ('PASTE-THEIR-AUTH-USER-ID-HERE', 'writer');
-- Use role 'reader' for read-only access.
