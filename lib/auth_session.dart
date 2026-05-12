import 'package:shared_preferences/shared_preferences.dart';

/// Sesión de usuario persistida en SharedPreferences.
///
/// Implementa el comportamiento de "Mantener sesión iniciada" del login:
/// - Si el usuario marca el checkbox al entrar, `save(...)` guarda el flag y
///   el correo. En el siguiente arranque, `SplashPage` lee `isActive()` y
///   salta el login directamente.
/// - `clear()` se llama en "Cerrar sesión" para invalidar la sesión.
///
/// NOTA: este proyecto es un demo sin backend real, así que la sesión es
/// puramente local (no hay token ni expiración real). Cuando se integre el
/// backend (rama `prueba-back-integrado` ya tiene Supabase), aquí se debería
/// guardar el token de Supabase y validar expiración.
class AuthSession {
  static final AuthSession _instance = AuthSession._internal();
  factory AuthSession() => _instance;
  AuthSession._internal();

  static const _kActive = 'auth_session_active';
  static const _kEmail = 'auth_session_email';

  bool _active = false;
  String _email = '';

  Future<void> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    _active = prefs.getBool(_kActive) ?? false;
    _email = prefs.getString(_kEmail) ?? '';
  }

  bool isActive() => _active;

  String get savedEmail => _email;

  Future<void> save({required String email, required bool remember}) async {
    final prefs = await SharedPreferences.getInstance();
    if (remember) {
      _active = true;
      _email = email;
      await prefs.setBool(_kActive, true);
      await prefs.setString(_kEmail, email);
    } else {
      // No persiste sesión, pero igualmente borra cualquier flag anterior
      // para que el próximo arranque vuelva al login.
      await clear();
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    _active = false;
    _email = '';
    await prefs.remove(_kActive);
    await prefs.remove(_kEmail);
  }
}
