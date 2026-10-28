-- One profile per auth user. id is auth.users.id, so deleting the user deletes the profile.
-- full_name and avatar_url are display fields copied once from signup metadata.
-- They are not used for authorization. raw_user_meta_data is user-editable.

create schema if not exists private;

revoke all on schema private from public;

-- Functions created later in this schema are not executable through the Data API.
alter default privileges in schema private
  revoke execute on functions from public;

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.profiles is
  'Application profile for an auth user. Each row is visible only to that user.';

-- Grants decide whether the Data API can see the table. RLS decides which rows.
-- Clients cannot insert or delete profiles: signup creates the row, and account
-- deletion cascades from auth.users.
grant select, update on table public.profiles to authenticated;
grant select, insert, update, delete on table public.profiles to service_role;

alter table public.profiles enable row level security;

create policy "Users can view their own profile"
  on public.profiles
  for select
  to authenticated
  using ((select auth.uid()) = id);

create policy "Users can update their own profile"
  on public.profiles
  for update
  to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- security definer so the insert runs as the function owner (postgres).
-- The auth service inserts as supabase_auth_admin, which cannot write public.profiles.
-- Do not force row level security on public.profiles: the owner must bypass RLS
-- for this insert, and there is no insert policy for clients.
create function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (
    new.id,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'avatar_url'
  );

  return new;
end;
$$;

revoke all on function private.handle_new_user() from public, anon, authenticated, service_role;
grant usage on schema private to supabase_auth_admin;
grant execute on function private.handle_new_user() to supabase_auth_admin;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function private.handle_new_user();

create function private.set_profiles_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = pg_catalog.now();
  return new;
end;
$$;

revoke all on function private.set_profiles_updated_at() from public;
grant usage on schema private to authenticated, service_role;
grant execute on function private.set_profiles_updated_at() to authenticated, service_role;

create trigger set_profiles_updated_at
  before update on public.profiles
  for each row
  execute function private.set_profiles_updated_at();
