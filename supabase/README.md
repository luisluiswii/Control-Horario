# Backend Supabase — Control Horario

Esta carpeta contiene todo lo necesario para configurar el lado servidor
de la app: esquema de BBDD, políticas RLS, Edge Function de alta de
trabajadores y un seed para crear la cuenta de admin inicial.

## Despliegue paso a paso

### 1. Aplicar el schema

En el proyecto de Supabase, abre el **SQL Editor** y pega el contenido de
[`schema.sql`](./schema.sql). Ejecuta. Es idempotente (usa `if not exists`),
por lo que se puede volver a ejecutar tras añadir columnas nuevas.

### 2. Crear el primer admin

1. Ve a **Authentication → Users → Add user**.
2. Introduce email + contraseña. Marca **Auto Confirm User**.
3. Copia el **UUID** del usuario recién creado.
4. Abre [`seed_admin.sql`](./seed_admin.sql), sustituye los placeholders
   (`PEGA_AQUI_EL_UUID...`, email, nombre) y ejecútalo en el SQL Editor.

A partir de aquí ese usuario ya puede iniciar sesión en la app y verá el
**Panel de Administración**.

### 3. Desplegar la Edge Function `crear-trabajador`

Esta función es lo que permite al admin dar de alta empleados con email y
contraseña temporal sin exponer el `service_role` en la app.

Desde la raíz del repo, con la [Supabase CLI](https://supabase.com/docs/guides/cli)
instalada y autenticada:

```bash
supabase link --project-ref <PROJECT_REF>
supabase functions deploy crear-trabajador
```

Las variables `SUPABASE_URL`, `SUPABASE_ANON_KEY` y `SUPABASE_SERVICE_ROLE_KEY`
se inyectan automáticamente, no hay que añadir nada manual.

### 4. Configurar la app Flutter

En `lib/main.dart` debe seguir apuntando al proyecto correcto en
`Supabase.initialize(url: ..., anonKey: ...)`. No hace falta tocar nada
más: la app llama a `supabase.functions.invoke('crear-trabajador', ...)`
con el JWT del admin, y la Edge Function valida el rol antes de crear.

## Flujo resumido

- **Admin** entra con su email y contraseña. La app detecta `rol='admin'`
  y abre el panel.
- Desde el panel pulsa **"Nuevo trabajador"** → rellena el formulario →
  la Edge Function crea la cuenta y marca `must_change_password=true`.
- El admin comparte las credenciales temporales con el empleado.
- **Empleado** entra con esas credenciales. La app detecta el flag y le
  obliga a cambiar la contraseña antes de continuar.
- Tras el cambio, accede a la app normalmente como `empleado`.
