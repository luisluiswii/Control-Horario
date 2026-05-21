create extension if not exists pgcrypto;

create table if not exists public.usuario (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null unique references auth.users (id) on delete cascade,
  email text not null unique,
  nombre_completo text not null,
  departamento text not null default '',
  identificacion text not null default '',
  rol text not null default 'empleado',
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.fichajes (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references auth.users (id) on delete cascade,
  tipo text not null check (tipo in ('entrada', 'salida')),
  fecha timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.turnos (
  id uuid primary key default gen_random_uuid(),
  fecha date not null,
  hora_inicio text not null,
  hora_fin text not null,
  rol text not null,
  ubicacion text not null default 'Sede Principal',
  urgencia text not null default 'Baja',
  urgencia_color text not null default 'success',
  asignado_usuario_id uuid references auth.users (id) on delete set null,
  asignado_usuario_nombre text,
  is_fixed boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.usuario enable row level security;
alter table public.fichajes enable row level security;
alter table public.turnos enable row level security;

create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.usuario u
    where u.auth_user_id = auth.uid()
      and u.rol = 'admin'
      and u.activo = true
  );
$$;

create policy "usuario_select_own_or_admin"
on public.usuario
for select
using (auth_user_id = auth.uid() or public.is_admin());

create policy "usuario_update_own_or_admin"
on public.usuario
for update
using (auth_user_id = auth.uid() or public.is_admin())
with check (auth_user_id = auth.uid() or public.is_admin());

create policy "fichajes_select_own_or_admin"
on public.fichajes
for select
using (usuario_id = auth.uid() or public.is_admin());

create policy "fichajes_insert_own_or_admin"
on public.fichajes
for insert
with check (usuario_id = auth.uid() or public.is_admin());

create policy "turnos_select_authenticated"
on public.turnos
for select
using (auth.role() = 'authenticated');

create policy "turnos_manage_admin"
on public.turnos
for all
using (public.is_admin())
with check (public.is_admin());