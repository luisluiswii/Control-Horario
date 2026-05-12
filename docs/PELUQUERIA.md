# Rama `peluqueria`

Esta rama adapta la plantilla común de **Control Horario** al perfil de una
**peluquería de 4 personas**. El proyecto está pensado como plantilla para 3
empresas distintas (ver README de `main`), por lo que **no se borra código**:
todo lo que no aplica a la peluquería queda **comentado** con la marca
`[peluquería]` para que cualquiera de las otras empresas pueda partir de la
misma base sin perder funcionalidad.

Base: rama `Temporal` (la más completa al momento de crear esta rama, incluye
gestión de módulos con persistencia vía `SharedPreferences`).

---

## 1. Módulos del menú desactivados

Se han comentado 5 entradas del menú principal por considerarlas innecesarias
o desproporcionadas para un equipo de 4 personas:

| Módulo | Motivo de desactivación |
|---|---|
| **Aprobaciones** | Flujo formal de aprobaciones (vacaciones, gastos…). En un equipo de 4 personas se resuelve hablando con el responsable, no hace falta workflow. |
| **Encuesta 360°** | Evaluación de desempeño entre compañeros estilo corporativo. No tiene sentido a esta escala. |
| **Cursos** | Catálogo de formación interna. Una peluquería pequeña no gestiona formación reglada desde la app. |
| **Asistencias** | Resolución formal de faltas/justificantes. Solapa con "Vacaciones" y añade fricción innecesaria. |
| **Asistencia App** | FAQ / soporte interno tipo empresa grande. Sobra a esta escala. |

**Módulos que se mantienen activos:** Vacaciones, Nóminas, Tablón, Añadir
tareas, Documentos, Gestión, Cambiar turno, Trabajadores, Quejas y
Gestionar módulos.

### Archivos tocados

- `lib/main.dart` → lista `menuItems` dentro de `_MenuPlaceholderPageState.build`.
- `lib/modules_management_page.dart` → mapas `_activos` y `_iconos` de
  `ModulesManager` / `_ModulesManagementPageState`.

Las rutas de navegación (`Navigator.push(... XPage())`) **se dejan intactas**
porque los imports y clases siguen siendo válidos: aunque el módulo no
aparezca en el menú, su código sigue en el repo y otras ramas lo usan.

### Cómo reactivar un módulo en esta rama

1. Descomentar la línea correspondiente en `lib/main.dart` (`menuItems`).
2. Descomentar la misma entrada en `lib/modules_management_page.dart` en
   ambos mapas (`_activos` y `_iconos`).
3. Listo. La pantalla "Gestionar módulos" del menú permitirá además al
   administrador activar/desactivar ese módulo en caliente sin tocar código.

### Cómo añadir un módulo nuevo (recordatorio)

Mantener los 3 sitios sincronizados:

1. Una entrada en `menuItems` de `main.dart` (con su `else if` de navegación
   en el `onTap`).
2. Una entrada en `_activos` de `modules_management_page.dart`.
3. Una entrada en `_iconos` de `modules_management_page.dart`.

---

## 2. Login: "Mantener sesión iniciada" y "Olvidé la contraseña"

Antes de esta rama ambos controles estaban en la UI pero **no hacían nada**:

- El checkbox "Mantener sesión iniciada" solo cambiaba un `bool` en memoria
  que no se leía en ningún sitio.
- El botón "¿Olvidaste tu clave?" mostraba un `SnackBar` con el mensaje
  *"Función de recuperación en próxima versión"*.

### Cambios

#### Nuevo archivo `lib/auth_session.dart`

Singleton `AuthSession` que persiste la sesión en `SharedPreferences`:

- `cargar()` — se llama en `main()` antes de arrancar la app.
- `isActive()` — `true` si hay sesión guardada.
- `savedEmail` — correo guardado para precargar el campo en el login.
- `save({email, remember})` — guarda flag y correo si `remember=true`; si no,
  limpia.
- `clear()` — borra la sesión al cerrar sesión.

Como este branch aún no tiene backend real (la rama `JuanR-Pablo` ya tiene
Supabase pero no está mergeada aquí), la sesión es puramente local. Cuando
se integre Supabase, sustituir `save/isActive/clear` para que usen el token
real con su expiración.

#### `lib/main.dart`

- `main()` ahora hace `await AuthSession().cargar()` además de los módulos.
- `SplashPage` decide a dónde navegar tras la animación:
  - sesión activa → `HomeShellPage` (panel principal)
  - sin sesión → `LoginPage`
- `LoginPage`:
  - `initState` precarga el correo si quedó guardado.
  - `_submit()` llama a `AuthSession().save(email, _remember)` antes de
    navegar, así el flag queda persistido para el próximo arranque.
  - "¿Olvidaste tu clave?" abre `_showForgotPasswordDialog`, un diálogo con
    validación de correo y feedback (mensaje neutro estilo *"si el correo
    existe, recibirás un enlace"*) — apto para reemplazar por
    `Supabase.auth.resetPasswordForEmail` cuando haya backend.
- "Cerrar sesión" (panel Perfil) ahora hace `await AuthSession().clear()`
  antes de volver al login; si no, el siguiente arranque saltaba el login
  aunque el usuario hubiese cerrado sesión.

---

## 3. Cómo probar en local

```bash
flutter pub get
flutter run -d chrome   # o el device-id del emulador Android
```

Checklist:

- [ ] El menú principal muestra **10 botones** (incluyendo "Gestionar módulos")
      en lugar de los 15 originales.
- [ ] "Gestionar módulos" muestra solo los 9 módulos toggleables (Aprobaciones,
      Encuesta 360°, Cursos, Asistencias y Asistencia App ya no aparecen).
- [ ] Marcar "Mantener sesión iniciada", entrar, cerrar la app y reabrirla →
      tras la splash, entra directo al panel (sin login).
- [ ] Sin marcar el checkbox, entrar, cerrar la app y reabrirla → vuelve al
      login.
- [ ] Login con sesión guardada → el correo aparece pre-rellenado.
- [ ] "Cerrar sesión" desde el panel Perfil → siguiente arranque vuelve al
      login.
- [ ] Pulsar "¿Olvidaste tu clave?" → abre diálogo, valida correo y muestra
      mensaje de confirmación.
