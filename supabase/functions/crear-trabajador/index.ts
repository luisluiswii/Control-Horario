// Edge Function: crear-trabajador
//
// Endpoint protegido: solo lo puede invocar un usuario autenticado cuyo rol
// en `public.usuario` sea `admin`. Crea un usuario en `auth.users` con
// email/contraseña temporal y la fila correspondiente en `public.usuario`
// con `must_change_password = true` para forzar el cambio en el primer login.
//
// Requiere variables de entorno (las inyecta Supabase automáticamente):
//   - SUPABASE_URL
//   - SUPABASE_SERVICE_ROLE_KEY
//   - SUPABASE_ANON_KEY

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type Payload = {
  email?: string;
  password?: string;
  nombre_completo?: string;
  departamento?: string;
  identificacion?: string;
};

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
  });
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "Método no permitido" }, 405);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");

  if (!supabaseUrl || !serviceRoleKey || !anonKey) {
    return jsonResponse({ error: "Edge Function mal configurada" }, 500);
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader.toLowerCase().startsWith("bearer ")) {
    return jsonResponse({ error: "Falta token de sesión" }, 401);
  }
  const jwt = authHeader.slice("bearer ".length).trim();

  // Cliente con el JWT del invocador: usado solo para identificarlo.
  const supabaseAsCaller = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  });

  const { data: callerData, error: callerError } =
    await supabaseAsCaller.auth.getUser();

  if (callerError || !callerData?.user) {
    return jsonResponse({ error: "Sesión inválida" }, 401);
  }

  // Cliente con service_role: bypassea RLS para comprobar rol y crear cuenta.
  const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: callerProfile, error: profileError } = await supabaseAdmin
    .from("usuario")
    .select("rol, activo")
    .eq("auth_user_id", callerData.user.id)
    .maybeSingle();

  if (profileError) {
    return jsonResponse(
      { error: "No se pudo verificar el perfil del usuario" },
      500,
    );
  }
  if (!callerProfile || callerProfile.rol !== "admin" || callerProfile.activo === false) {
    return jsonResponse({ error: "Permisos insuficientes" }, 403);
  }

  let payload: Payload;
  try {
    payload = await req.json();
  } catch {
    return jsonResponse({ error: "JSON inválido" }, 400);
  }

  const email = (payload.email ?? "").trim().toLowerCase();
  const password = (payload.password ?? "").trim();
  const nombreCompleto = (payload.nombre_completo ?? "").trim();
  const departamento = (payload.departamento ?? "").trim();
  const identificacion = (payload.identificacion ?? "").trim();

  if (!email || !email.includes("@")) {
    return jsonResponse({ error: "Email inválido" }, 400);
  }
  if (password.length < 8) {
    return jsonResponse(
      { error: "La contraseña temporal debe tener al menos 8 caracteres" },
      400,
    );
  }
  if (!nombreCompleto) {
    return jsonResponse({ error: "El nombre completo es obligatorio" }, 400);
  }

  // 1) Crear usuario en Supabase Auth con email confirmado (no envía mail).
  const { data: created, error: createError } =
    await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { nombre_completo: nombreCompleto },
    });

  if (createError || !created.user) {
    return jsonResponse(
      { error: createError?.message ?? "No se pudo crear el usuario" },
      400,
    );
  }

  // 2) Insertar fila en public.usuario.
  const { error: insertError } = await supabaseAdmin.from("usuario").insert({
    auth_user_id: created.user.id,
    email,
    nombre_completo: nombreCompleto,
    departamento,
    identificacion,
    rol: "empleado",
    activo: true,
    must_change_password: true,
  });

  if (insertError) {
    // Rollback: si falla la inserción del perfil, borramos el auth user.
    await supabaseAdmin.auth.admin.deleteUser(created.user.id);
    return jsonResponse({ error: insertError.message }, 400);
  }

  return jsonResponse({
    ok: true,
    user_id: created.user.id,
    email,
  });
});
