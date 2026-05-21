-- =============================================================
-- SEED: dos cuentas de prueba (1 admin + 1 worker).
--
-- Pasos:
--   1) Aplica primero `schema.sql` (crea las tablas y RLS).
--   2) En el panel de Supabase ve a Authentication → Users → "Add user"
--      y crea estos dos usuarios con email + contraseña (marca "Auto
--      Confirm User" para no tener que confirmar por email):
--
--        - admin@controlhorario.local   /   Admin1234!
--        - worker@controlhorario.local  /   Worker1234!
--
--   3) Copia los UUID de ambos usuarios (columna "UID" en el panel) y
--      pégalos en los dos INSERT de abajo, sustituyendo los placeholders.
--
--   4) Ejecuta este script en el SQL Editor de Supabase.
-- =============================================================

insert into public.usuario (
  auth_user_id, email, nombre_completo, departamento, identificacion, rol, activo
) values (
  'PEGA_AQUI_UUID_ADMIN'::uuid,
  'admin@controlhorario.local',
  'Administrador',
  'Administración',
  '',
  'admin',
  true
)
on conflict (auth_user_id) do update set
  rol = excluded.rol,
  activo = excluded.activo;

insert into public.usuario (
  auth_user_id, email, nombre_completo, departamento, identificacion, rol, activo
) values (
  'PEGA_AQUI_UUID_WORKER'::uuid,
  'worker@controlhorario.local',
  'Empleado de prueba',
  'Operaciones',
  '',
  'empleado',
  true
)
on conflict (auth_user_id) do update set
  rol = excluded.rol,
  activo = excluded.activo;

-- Comprobación:
-- select email, rol, activo from public.usuario order by rol;
