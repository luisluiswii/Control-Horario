-- =============================================================
-- SEED: crear la cuenta de administrador inicial.
--
-- IMPORTANTE: para usar este script necesitas tener ya creado un usuario
-- en `auth.users` (panel Supabase → Authentication → Users → "Add user",
-- marcando "Auto Confirm User"). Una vez creado, copia su UUID y úsalo
-- en el INSERT siguiente.
--
-- Ejecuta este script desde el SQL Editor de Supabase (con permisos de
-- service_role) UNA SOLA VEZ por instalación.
-- =============================================================

-- 1) Sustituye estos valores antes de ejecutar:
--    - 'PEGA_AQUI_EL_UUID_DEL_USUARIO_AUTH'  → UUID del usuario recién creado en auth.users
--    - 'admin@empresa.com'                    → el email del admin (debe coincidir con auth.users)
--    - 'Administrador'                        → el nombre que verá en la app

insert into public.usuario (
  auth_user_id,
  email,
  nombre_completo,
  departamento,
  identificacion,
  rol,
  activo,
  must_change_password
) values (
  'PEGA_AQUI_EL_UUID_DEL_USUARIO_AUTH'::uuid,
  'admin@empresa.com',
  'Administrador',
  'Administración',
  '',
  'admin',
  true,
  false  -- el admin inicial NO necesita cambiar contraseña en su primer login
)
on conflict (auth_user_id) do update set
  rol = excluded.rol,
  activo = excluded.activo;

-- 2) Comprueba que ha quedado bien:
-- select id, email, rol, activo, must_change_password from public.usuario where rol = 'admin';
