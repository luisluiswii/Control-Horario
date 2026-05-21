# Backend Supabase — Control Horario

Esta carpeta contiene el esquema de la base de datos y un seed con dos
cuentas de prueba (un administrador y un trabajador) para que el equipo
pueda probar el flujo de login con los dos roles.

## Despliegue paso a paso

### 1. Aplicar el schema

Pega [`schema.sql`](./schema.sql) en el **SQL Editor** del proyecto
Supabase y ejecútalo. Es idempotente (`if not exists`), así que se
puede volver a ejecutar sin romper nada.

### 2. Crear los dos usuarios en Authentication

En el panel **Authentication → Users → "Add user"** crea estos dos
(marcando **Auto Confirm User** en ambos para evitar el email de
confirmación):

| Email                          | Contraseña    | Rol      |
|--------------------------------|---------------|----------|
| `admin@controlhorario.local`   | `Admin1234!`  | admin    |
| `worker@controlhorario.local`  | `Worker1234!` | empleado |

### 3. Vincular los UUID y ejecutar el seed

Copia el **UID** que aparece en el panel para cada uno, ábrelos en
[`seed_users.sql`](./seed_users.sql), sustituye los placeholders
`PEGA_AQUI_UUID_ADMIN` y `PEGA_AQUI_UUID_WORKER`, y ejecuta el script.

### 4. Probar la app

En la app Flutter (`Supabase.initialize` ya apunta al proyecto correcto
desde `lib/main.dart`):

- Login con `admin@controlhorario.local` → entra al **Panel de
  Administración** con la lista de empleados.
- Login con `worker@controlhorario.local` → entra al home normal del
  trabajador (`HomeShellPage`).

## Privilegios (definidos por RLS en `schema.sql`)

- **Admin** (`is_admin()` devuelve `true`):
  - Ve y edita todos los registros de `usuario`.
  - Ve todos los `fichajes`.
  - Gestiona (crea/edita/borra) los `turnos`.
- **Empleado**:
  - Ve y edita solo su propia fila en `usuario`.
  - Ve e inserta solo sus propios `fichajes`.
  - Ve los `turnos` pero no los puede modificar.
