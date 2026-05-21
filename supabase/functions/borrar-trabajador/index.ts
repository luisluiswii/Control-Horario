// Edge Function: borrar-trabajador
//
// Borra físicamente un usuario de `auth.users`. Gracias al `on delete
// cascade` definido en el schema, la fila correspondiente en
// `public.usuario` y todos sus `fichajes` se borran también.
//
// Solo puede invocarla un usuario autenticado cuyo rol en
// `public.usuario` sea `admin`. Un admin no puede borrarse a sí mismo.
//
// Body esperado: { "auth_user_id": "<uuid>" }

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
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

  // 1) Identificar al invocador a partir de su JWT.
  const supabaseAsCaller = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  });
  const { data: callerData, error: callerError } =
    await supabaseAsCaller.auth.getUser();
  if (callerError || !callerData?.user) {
    return jsonResponse({ error: "Sesión inválida" }, 401);
  }

  // 2) Cliente con service_role para validar rol y borrar.
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
      { error: "No se pudo verificar el perfil del invocador" },
      500,
    );
  }
  if (
    !callerProfile ||
    callerProfile.rol !== "admin" ||
    callerProfile.activo === false
  ) {
    return jsonResponse({ error: "Permisos insuficientes" }, 403);
  }

  // 3) Leer body.
  let payload: { auth_user_id?: string };
  try {
    payload = await req.json();
  } catch {
    return jsonResponse({ error: "JSON inválido" }, 400);
  }
  const targetId = (payload.auth_user_id ?? "").trim();
  if (!targetId) {
    return jsonResponse({ error: "Falta auth_user_id" }, 400);
  }
  if (targetId === callerData.user.id) {
    return jsonResponse(
      { error: "Un administrador no puede eliminarse a sí mismo" },
      400,
    );
  }

  // 4) Borrar de auth.users. El `on delete cascade` del schema limpia
  // `public.usuario` y `public.fichajes` automáticamente.
  const { error: deleteError } =
    await supabaseAdmin.auth.admin.deleteUser(targetId);
  if (deleteError) {
    return jsonResponse({ error: deleteError.message }, 400);
  }

  return jsonResponse({ ok: true, deleted: targetId });
});
