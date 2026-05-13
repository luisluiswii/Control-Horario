import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/gestures.dart';
import 'gestion_page.dart';
import 'anadir_tareas_page.dart';
import 'documentos_page.dart';
import 'encuesta_page.dart';
import 'cambiar_turno_page.dart';
import 'trabajadores_page.dart';
import 'cursos_page.dart';
import 'asistencias_page.dart';
import 'quejas_page.dart';
import 'vacaciones_page.dart';
import 'nominas_page.dart';
import 'aprobaciones_page.dart';
import 'tablon_page.dart';
import 'asistencia_app_page.dart';
import 'registro_page.dart';
import 'supabase_app_repository.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es_ES', null);

  await Supabase.initialize(
    url: 'https://htmumknfebjqjvjwcvug.supabase.co',
    anonKey: 'sb_publishable_07XgshcqADVom9neTKotTA_4bnCRtR1',
  );

  runApp(const ControlHorarioApp());
}

class AppColors {
  static Color background = const Color(0xFFF0F9FF);
  static Color surface = const Color(0xFFFFFFFF);
  static Color primaryTeal = const Color(0xFF0C4A6E);
  static Color primaryTealLight = const Color(0xFF0284C7);
  static Color accentCoral = const Color(0xFF0EA5E9);
  static Color accentSky = const Color(0xFF38BDF8);

  static Color successGreen = const Color(0xFF10B981);
  static Color warningOrange = const Color(0xFFF59E0B);
  static Color dangerRed = const Color(0xFFEF4444);

  static Color white = const Color(0xFFFFFFFF);
  static Color textPrimary = const Color(0xFF082F49);
  static Color textSecondary = const Color(0xFF475569);
  static Color border = const Color(0xFFE0F2FE);

  static int currentTheme = 0;

  static void setTheme(int index) {
    currentTheme = index;
    if (index == 0) {
      background = const Color(0xFFF0F9FF);
      surface = const Color(0xFFFFFFFF);
      primaryTeal = const Color(0xFF0C4A6E);
      primaryTealLight = const Color(0xFF0284C7);
      accentCoral = const Color(0xFF0EA5E9);
      accentSky = const Color(0xFF38BDF8);
      successGreen = const Color(0xFF10B981);
      warningOrange = const Color(0xFFF59E0B);
      dangerRed = const Color(0xFFEF4444);
      white = const Color(0xFFFFFFFF);
      textPrimary = const Color(0xFF082F49);
      textSecondary = const Color(0xFF475569);
      border = const Color(0xFFE0F2FE);
    } else if (index == 1) {
      background = const Color(0xFFF0F9FF);
      surface = const Color(0xFFFFFFFF);
      primaryTeal = const Color(0xFF0C4A6E);
      primaryTealLight = const Color(0xFF0284C7);
      accentCoral = const Color(0xFF0EA5E9);
      accentSky = const Color(0xFF38BDF8);
      successGreen = const Color(0xFF10B981);
      warningOrange = const Color(0xFFF59E0B);
      dangerRed = const Color(0xFFEF4444);
      white = const Color(0xFFFFFFFF);
      textPrimary = const Color(0xFF082F49);
      textSecondary = const Color(0xFF475569);
      border = const Color(0xFFE0F2FE);
    } else if (index == 2) {
      background = const Color(0xFFF0FDF4);
      surface = const Color(0xFFFFFFFF);
      primaryTeal = const Color(0xFF064E3B);
      primaryTealLight = const Color(0xFF059669);
      accentCoral = const Color(0xFF10B981);
      accentSky = const Color(0xFF34D399);
      successGreen = const Color(0xFF059669);
      warningOrange = const Color(0xFFD97706);
      dangerRed = const Color(0xFFDC2626);
      white = const Color(0xFFFFFFFF);
      textPrimary = const Color(0xFF022C22);
      textSecondary = const Color(0xFF475569);
      border = const Color(0xFFDCFCE7);
    } else if (index == 3) {
      background = const Color(0xFF0F172A);
      surface = const Color(0xFF1E293B);
      primaryTeal = const Color(0xFFE2E8F0);
      primaryTealLight = const Color(0xFF94A3B8);
      accentCoral = const Color(0xFF3B82F6);
      accentSky = const Color(0xFF60A5FA);
      successGreen = const Color(0xFF10B981);
      warningOrange = const Color(0xFFF59E0B);
      dangerRed = const Color(0xFFEF4444);
      white = const Color(0xFF1E293B);
      textPrimary = const Color(0xFFF8FAFC);
      textSecondary = const Color(0xFF94A3B8);
      border = const Color(0xFF334155);
    } else if (index == 4) {
      background = const Color(0xFFFFF7ED);
      surface = const Color(0xFFFFFFFF);
      primaryTeal = const Color(0xFFC2410C);
      primaryTealLight = const Color(0xFFEA580C);
      accentCoral = const Color(0xFFF97316);
      accentSky = const Color(0xFFFDBA74);
      successGreen = const Color(0xFF10B981);
      warningOrange = const Color(0xFFF59E0B);
      dangerRed = const Color(0xFFEF4444);
      white = const Color(0xFFFFFFFF);
      textPrimary = const Color(0xFF431407);
      textSecondary = const Color(0xFF78350F);
      border = const Color(0xFFFFEDD5);
    } else if (index == 5) {
      background = const Color(0xFFFAF5FF);
      surface = const Color(0xFFFFFFFF);
      primaryTeal = const Color(0xFF6B21A8);
      primaryTealLight = const Color(0xFF9333EA);
      accentCoral = const Color(0xFFA855F7);
      accentSky = const Color(0xFFD8B4FE);
      successGreen = const Color(0xFF10B981);
      warningOrange = const Color(0xFFF59E0B);
      dangerRed = const Color(0xFFEF4444);
      white = const Color(0xFFFFFFFF);
      textPrimary = const Color(0xFF3B0764);
      textSecondary = const Color(0xFF581C87);
      border = const Color(0xFFF3E8FF);
    } else if (index == 6) {
      background = const Color(0xFF020617);
      surface = const Color(0xFF0F172A);
      primaryTeal = const Color(0xFF38BDF8);
      primaryTealLight = const Color(0xFF7DD3FC);
      accentCoral = const Color(0xFF0EA5E9);
      accentSky = const Color(0xFFBAE6FD);
      successGreen = const Color(0xFF10B981);
      warningOrange = const Color(0xFFF59E0B);
      dangerRed = const Color(0xFFEF4444);
      white = const Color(0xFF0F172A);
      textPrimary = const Color(0xFFF8FAFC);
      textSecondary = const Color(0xFF94A3B8);
      border = const Color(0xFF1E293B);
    }
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class ControlHorarioApp extends StatefulWidget {
  const ControlHorarioApp({super.key});

  static ControlHorarioAppState of(BuildContext context) =>
      context.findAncestorStateOfType<ControlHorarioAppState>()!;

  @override
  State<ControlHorarioApp> createState() => ControlHorarioAppState();
}

class ControlHorarioAppState extends State<ControlHorarioApp> {
  Key _appKey = UniqueKey();

  void changeTheme(int index) {
    setState(() {
      AppColors.setTheme(index);
      _appKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _appKey,
      title: 'Control Horario',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness:
              (AppColors.currentTheme == 3 || AppColors.currentTheme == 6)
              ? Brightness.dark
              : Brightness.light,
          seedColor: AppColors.primaryTeal,
          primary: AppColors.primaryTeal,
          secondary: AppColors.accentCoral,
          surface: AppColors.surface,
        ),
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTeal,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: BorderSide(color: AppColors.border, width: 2),
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryTeal, width: 2),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final Animation<Offset> _slideAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _navigationTimer = Timer(const Duration(milliseconds: 2400), () async {
      if (!mounted) return;

      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        try {
          final data = await Supabase.instance.client
              .from('usuario')
              .select('rol, activo')
              .eq('auth_user_id', session.user.id)
              .maybeSingle();

          if (!mounted) return;

          if (data != null && data['activo'] == true) {
            // Nota: aquí podríamos enrutar a una 'AdminPage()' si rol es admin,
            // pero para el flujo general vamos al Dashboard principal de la app.
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeShellPage()),
            );
            return;
          }
        } catch (_) {
          // Si hay algún fallo de red o el usuario fue borrado, forzamos login
          await Supabase.instance.client.auth.signOut();
        }
      }

      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 114,
                    height: 114,
                    color: AppColors.primaryTealLight,
                    colorBlendMode: BlendMode.color,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Control Horario',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Registro simple, claro y rápido',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 26),
                SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryTealLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _remember = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) {
        throw Exception('No se pudo iniciar sesión');
      }

      final data = await Supabase.instance.client
          .from('usuario')
          .select()
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (data == null) {
        throw Exception('Tu cuenta no está configurada correctamente');
      }

      if (data['activo'] == false) {
        throw Exception('Tu cuenta está desactivada');
      }

      final rol = data['rol'];

      if (rol == 'admin') {
        Navigator.of(context).pushReplacementNamed('/admin');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeShellPage()),
        );
      }
    } catch (e) {
      String mensajeError = 'Ocurrió un error inesperado.';

      if (e.toString().contains('invalid_credentials')) {
        mensajeError = 'Correo o contraseña incorrectos.';
      } else if (e.toString().contains('User not found')) {
        mensajeError = 'No existe una cuenta con ese correo.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensajeError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 14),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 100,
                    height: 100,
                    color: AppColors.primaryTealLight,
                    colorBlendMode: BlendMode.color,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Inicia Sesión',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty) {
                                  return 'Ingresa tu correo.';
                                }
                                if (!email.contains('@')) {
                                  return 'Correo inválido.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              validator: (value) {
                                if ((value ?? '').isEmpty) {
                                  return 'Ingresa tu contraseña.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: _remember,
                                  onChanged: (value) {
                                    setState(() => _remember = value ?? false);
                                  },
                                ),
                                const Expanded(
                                  child: Text('Mantener sesión iniciada'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Función de recuperación en próxima versión.',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('¿Olvidaste tu clave?'),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _submit,
                                icon: Icon(Icons.login),
                                label: Text('Acceder al panel'),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: AppColors.border),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'O',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: AppColors.border),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Simulando biometría... Funcionalidad en desarrollo.',
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.fingerprint,
                                  color: AppColors.primaryTeal,
                                ),
                                label: Text(
                                  'Iniciar con Huella/Face ID',
                                  style: TextStyle(
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegistroPage(),
                                  ),
                                );
                              },
                              child: Text(
                                '¿No tienes cuenta? Regístrate aquí',
                                style: TextStyle(
                                  color: AppColors.primaryTealLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum TipoRegistro { entrada, salida }

class RegistroHorario {
  const RegistroHorario({required this.tipo, required this.fecha});

  final TipoRegistro tipo;
  final DateTime fecha;
}

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _currentIndex = 0;
  late final PageController _pageController;
  final List<RegistroHorario> _registros = [];
  PerfilUsuario? _perfil;
  bool _cargando = true;
  String? _errorCarga;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _cargarEstadoInicial();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _cargarEstadoInicial() async {
    setState(() {
      _cargando = true;
      _errorCarga = null;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('Sesión no encontrada');
      }

      final perfil = await SupabaseAppRepository.loadCurrentProfile();
      final registrosRemotos = await SupabaseAppRepository.loadDayAttendance(
        user.id,
        DateTime.now(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _perfil = perfil;
        _registros
          ..clear()
          ..addAll(
            registrosRemotos.map(
              (registro) => RegistroHorario(
                tipo: registro.tipo == 'salida'
                    ? TipoRegistro.salida
                    : TipoRegistro.entrada,
                fecha: registro.fecha,
              ),
            ),
          );
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorCarga = e.toString();
        _cargando = false;
      });
    }
  }

  bool get _jornadaAbierta {
    if (_registros.isEmpty) return false;
    return _registros.first.tipo == TipoRegistro.entrada;
  }

  Duration get _tiempoAcumulado {
    if (_registros.isEmpty) return Duration.zero;
    final ordenados = [..._registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    DateTime? entradaAbierta;
    var total = Duration.zero;

    for (final registro in ordenados) {
      if (registro.tipo == TipoRegistro.entrada) {
        entradaAbierta ??= registro.fecha;
      } else if (entradaAbierta != null) {
        total += registro.fecha.difference(entradaAbierta);
        entradaAbierta = null;
      }
    }

    if (entradaAbierta != null) {
      total += DateTime.now().difference(entradaAbierta);
    }

    if (total.isNegative) return Duration.zero;
    return total;
  }

  Future<void> _registrar(TipoRegistro tipo) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return;
    }

    await SupabaseAppRepository.registerAttendance(
      authUserId: user.id,
      tipo: tipo == TipoRegistro.salida ? 'salida' : 'entrada',
    );

    await _cargarEstadoInicial();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorCarga != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                Text(
                  'No se pudo cargar la sesión',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorCarga!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _cargarEstadoInicial,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screens = [
      ControlHorarioPage(
        registros: _registros,
        jornadaAbierta: _jornadaAbierta,
        tiempoAcumulado: _tiempoAcumulado,
        onRegistrar: _registrar,
      ),
      CalendarioPage(registros: _registros),
      const MenuPlaceholderPage(),
      PerfilPage(perfil: _perfil),
    ];

    final titles = ['Inicio', 'Calendario', 'Menú', 'Perfil'];

    return Scaffold(
      appBar: _currentIndex == 1
          ? null
          : AppBar(
              title: Text(titles[_currentIndex]),
              centerTitle: false,
              backgroundColor: AppColors.background,
            ),
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: AppColors.primaryTeal.withValues(alpha: 0.14),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: AppColors.surface,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Menú',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class MenuPlaceholderPage extends StatelessWidget {
  const MenuPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos los items usando tu paleta Océano
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Vacaciones',
        'icon': Icons.flight_takeoff,
        'color': AppColors.accentCoral,
      },
      {
        'title': 'Nóminas',
        'icon': Icons.account_balance_wallet,
        'color': AppColors.successGreen,
      },
      {
        'title': 'Aprobaciones',
        'icon': Icons.fact_check,
        'color': AppColors.warningOrange,
      },
      {
        'title': 'Tablón',
        'icon': Icons.campaign,
        'color': AppColors.primaryTeal,
      },
      {
        'title': 'Añadir tareas',
        'icon': Icons.add_task,
        'color': AppColors.primaryTealLight,
      },
      {
        'title': 'Documentos',
        'icon': Icons.description_outlined,
        'color': AppColors.primaryTealLight,
      },
      {
        'title': 'Encuesta 360°',
        'icon': Icons.view_in_ar_outlined,
        'color': AppColors.warningOrange,
      },
      {
        'title': 'Gestión',
        'icon': Icons.settings_outlined,
        'color': AppColors.primaryTeal,
      },
      {
        'title': 'Cambiar turno',
        'icon': Icons.swap_horiz,
        'color': AppColors.primaryTealLight,
      },
      {
        'title': 'Trabajadores',
        'icon': Icons.people_outline,
        'color': AppColors.successGreen,
      },
      {
        'title': 'Cursos',
        'icon': Icons.school_outlined,
        'color': AppColors.primaryTealLight,
      },
      {
        'title': 'Asistencias',
        'icon': Icons.headset_mic_outlined,
        'color': AppColors.dangerRed,
      },
      {
        'title': 'Asistencia App',
        'icon': Icons.help_outline,
        'color': AppColors.accentSky,
      },
      {
        'title': 'Quejas',
        'icon': Icons.chat_bubble_outline,
        'color': AppColors.warningOrange,
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Menú',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Explora las herramientas disponibles',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.15,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final Color iconColor = item['color'];

                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        if (item['icon'] == Icons.settings_outlined) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GestionPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.add_task) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnadirTareasPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.description_outlined) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DocumentosPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.view_in_ar_outlined) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EncuestaPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.swap_horiz) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CambiarTurnoPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.people_outline) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrabajadoresPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.school_outlined) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CursosPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.headset_mic_outlined) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AsistenciasPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.help_outline) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AsistenciaAppPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.chat_bubble_outline) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuejasPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.flight_takeoff) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VacacionesPage(),
                            ),
                          );
                        } else if (item['icon'] ==
                            Icons.account_balance_wallet) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NominasPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.fact_check) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AprobacionesPage(),
                            ),
                          );
                        } else if (item['icon'] == Icons.campaign) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TablonPage(),
                            ),
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['icon'],
                              color: iconColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class JornadaResumenPage extends StatelessWidget {
  const JornadaResumenPage({
    required this.jornadaAbierta,
    required this.entradas,
    required this.salidas,
    required this.tiempoAcumulado,
    required this.onRegistrar,
    super.key,
  });

  final bool jornadaAbierta;
  final int entradas;
  final int salidas;
  final Duration tiempoAcumulado;
  final Future<void> Function(TipoRegistro) onRegistrar;

  String _formatearDuracion(Duration duracion) {
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$horas h $minutos min';
  }

  String _hora(DateTime fecha) {
    final horas = fecha.hour.toString().padLeft(2, '0');
    final minutos = fecha.minute.toString().padLeft(2, '0');
    return '$horas:$minutos';
  }

  @override
  Widget build(BuildContext context) {
    final progreso = (tiempoAcumulado.inMinutes / 480).clamp(0.0, 1.0);
    final restante = Duration(
      minutes: (480 - tiempoAcumulado.inMinutes).clamp(0, 480),
    );
    final salidaEstimada = DateTime.now().add(restante);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado de jornada',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          jornadaAbierta
                              ? Icons.play_circle_fill
                              : Icons.pause_circle,
                          color: jornadaAbierta
                              ? AppColors.successGreen
                              : AppColors.textSecondary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          jornadaAbierta
                              ? 'Jornada activa (pendiente de salida)'
                              : 'Sin jornada activa',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tiempo acumulado',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        Text(
                          _formatearDuracion(tiempoAcumulado),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: progreso,
                        backgroundColor: AppColors.background,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        jornadaAbierta
                            ? 'Salida estimada para completar 8h: ${_hora(salidaEstimada)}'
                            : 'Meta de jornada diaria: 8h de trabajo efectivo',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Entradas',
                    value: entradas.toString(),
                    color: AppColors.successGreen,
                    icon: Icons.login,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    label: 'Salidas',
                    value: salidas.toString(),
                    color: AppColors.warningOrange,
                    icon: Icons.logout,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: jornadaAbierta
                        ? null
                        : () => onRegistrar(TipoRegistro.entrada),
                    icon: Icon(Icons.login),
                    label: Text('Iniciar jornada'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: jornadaAbierta
                        ? () => onRegistrar(TipoRegistro.salida)
                        : null,
                    icon: Icon(Icons.logout),
                    label: Text('Finalizar jornada'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HistorialPage extends StatefulWidget {
  const HistorialPage({required this.registros, super.key});

  final List<RegistroHorario> registros;

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  int _filtro = 0;

  String _hora(DateTime fecha) {
    final horas = fecha.hour.toString().padLeft(2, '0');
    final minutos = fecha.minute.toString().padLeft(2, '0');
    return '$horas:$minutos';
  }

  String _fecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  List<RegistroHorario> _filtrarRegistros(int filtro) {
    if (filtro == 1) {
      return widget.registros
          .where((item) => item.tipo == TipoRegistro.entrada)
          .toList();
    }
    if (filtro == 2) {
      return widget.registros
          .where((item) => item.tipo == TipoRegistro.salida)
          .toList();
    }
    return widget.registros;
  }

  @override
  Widget build(BuildContext context) {
    final opciones = const ['Todos', 'Entradas', 'Salidas'];
    final registrosFiltrados = _filtrarRegistros(_filtro);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primaryTeal),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtros de búsqueda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${widget.registros.length} registros en total',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          opciones.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(
                                opciones[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _filtro == index
                                      ? AppColors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                              selected: _filtro == index,
                              onSelected: (_) =>
                                  setState(() => _filtro = index),
                              selectedColor: AppColors.primaryTeal,
                              backgroundColor: AppColors.background,
                              side: BorderSide(
                                color: _filtro == index
                                    ? Colors.transparent
                                    : AppColors.border,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Resultados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: registrosFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history,
                              size: 48,
                              color: AppColors.border,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay resultados',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Prueba con otro filtro de búsqueda.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: registrosFiltrados.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final registro = registrosFiltrados[index];
                          final esEntrada =
                              registro.tipo == TipoRegistro.entrada;
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      (esEntrada
                                              ? AppColors.successGreen
                                              : AppColors.warningOrange)
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  esEntrada
                                      ? Icons.login_rounded
                                      : Icons.logout_rounded,
                                  color: esEntrada
                                      ? AppColors.successGreen
                                      : AppColors.warningOrange,
                                ),
                              ),
                              title: Text(
                                esEntrada ? 'Entrada' : 'Salida',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                _fecha(registro.fecha),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: Text(
                                _hora(registro.fecha),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarioPage extends StatefulWidget {
  final List<RegistroHorario> registros;

  const CalendarioPage({required this.registros, super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late DateTime _focusedMonth;
  int? _selectedDay;
  late Map<DateTime, List<RegistroHorario>> _registrosPorDia;
  List<CalendarioEventoRemote> _eventos = [];
  bool _eventosLoading = false;
  String? _eventosError;

  late PageController _pageController;
  final int _initialPage = 1200;

  @override
  void initState() {
    super.initState();
    _registrosPorDia = _groupByDay(widget.registros);
    _focusedMonth = _initialMonth();
    _selectedDay = _initialSelectedDay();
    _pageController = PageController(initialPage: _initialPage);
    _loadEventosForMonth();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _dayKey(DateTime fecha) => DateTime(fecha.year, fecha.month, fecha.day);

  Map<DateTime, List<RegistroHorario>> _groupByDay(
    List<RegistroHorario> registros,
  ) {
    final Map<DateTime, List<RegistroHorario>> grouped = {};
    for (final registro in registros) {
      final key = _dayKey(registro.fecha);
      grouped.putIfAbsent(key, () => []).add(registro);
    }
    return grouped;
  }

  DateTime _initialMonth() {
    if (widget.registros.isNotEmpty) {
      final first = widget.registros.first.fecha;
      return DateTime(first.year, first.month, 1);
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  int? _initialSelectedDay() {
    final now = DateTime.now();
    if (now.year == _focusedMonth.year && now.month == _focusedMonth.month) {
      return now.day;
    }
    return null;
  }

  int _daysInMonth(DateTime month) {
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  int _leadingEmptyDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    return (firstDay.weekday + 6) % 7;
  }

  void _onPageChanged(int index) {
    final delta = index - _initialPage;
    final baseMonth = _initialMonth();
    setState(() {
      _focusedMonth = DateTime(baseMonth.year, baseMonth.month + delta, 1);
      _selectedDay = null;
    });
    _loadEventosForMonth();
  }

  void _goToMonth(int delta) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _pageController.page!.round() + delta,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToToday() {
    final now = DateTime.now();
    final baseMonth = _initialMonth();
    final delta = (now.year - baseMonth.year) * 12 + now.month - baseMonth.month;
    
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _initialPage + delta,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
    
    setState(() {
      _selectedDay = now.day;
    });
  }

  Future<void> _loadEventosForMonth() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() {
      _eventosLoading = true;
      _eventosError = null;
    });

    try {
      final eventos = await SupabaseAppRepository.loadCalendarEventsForMonth(
        user.id,
        _focusedMonth,
      );

      if (!mounted) return;

      setState(() {
        _eventos = eventos;
        _eventosLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _eventosError = e.toString();
        _eventosLoading = false;
      });
    }
  }

  List<RegistroHorario> _registrosDelDia(DateTime day) {
    return _registrosPorDia[_dayKey(day)] ?? [];
  }

  List<CalendarioEventoRemote> _eventosDelDia(DateTime day) {
    final key = _dayKey(day);
    return _eventos.where((evento) => _dayKey(evento.fecha) == key).toList();
  }

  Color _eventColor(String tipo) {
    switch (tipo) {
      case 'incidencia':
        return AppColors.warningOrange;
      case 'ausencia':
        return AppColors.dangerRed;
      case 'reunion':
        return AppColors.primaryTealLight;
      default:
        return AppColors.successGreen;
    }
  }

  List<Color> _buildDotsForDay(DateTime day) {
    final registros = _registrosDelDia(day);
    final eventos = _eventosDelDia(day);
    final List<Color> dots = [];

    if (registros.isNotEmpty) {
      final entradas = registros.where((r) => r.tipo == TipoRegistro.entrada).length;
      final salidas = registros.where((r) => r.tipo == TipoRegistro.salida).length;
      if (entradas > 0 && salidas > 0) {
        dots.add(AppColors.successGreen);
      } else {
        dots.add(AppColors.warningOrange);
      }
    }

    for (final evento in eventos) {
      final color = _eventColor(evento.tipo);
      if (!dots.contains(color)) {
        dots.add(color);
      }
    }

    return dots;
  }

  int _asistenciasMes() {
    final Set<DateTime> dias = {};

    final monthEntries = _registrosPorDia.entries.where(
      (entry) => entry.key.year == _focusedMonth.year && entry.key.month == _focusedMonth.month,
    );
    for (final entry in monthEntries) {
      final registros = entry.value;
      final entradas = registros.where((r) => r.tipo == TipoRegistro.entrada).length;
      final salidas = registros.where((r) => r.tipo == TipoRegistro.salida).length;
      if (entradas > 0 && salidas > 0) {
        dias.add(entry.key);
      }
    }

    for (final evento in _eventos) {
      if (evento.fecha.year == _focusedMonth.year &&
          evento.fecha.month == _focusedMonth.month &&
          evento.tipo == 'asistencia') {
        dias.add(_dayKey(evento.fecha));
      }
    }

    return dias.length;
  }

  int _incidenciasMes() {
    final Set<DateTime> dias = {};

    final monthEntries = _registrosPorDia.entries.where(
      (entry) => entry.key.year == _focusedMonth.year && entry.key.month == _focusedMonth.month,
    );
    for (final entry in monthEntries) {
      final registros = entry.value;
      final entradas = registros.where((r) => r.tipo == TipoRegistro.entrada).length;
      final salidas = registros.where((r) => r.tipo == TipoRegistro.salida).length;
      if ((entradas > 0 && salidas == 0) || (entradas == 0 && salidas > 0)) {
        dias.add(entry.key);
      }
    }

    for (final evento in _eventos) {
      if (evento.fecha.year == _focusedMonth.year &&
          evento.fecha.month == _focusedMonth.month &&
          evento.tipo == 'incidencia') {
        dias.add(_dayKey(evento.fecha));
      }
    }

    return dias.length;
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM yyyy', 'es_ES').format(_focusedMonth);
    final leadingEmpty = _leadingEmptyDays(_focusedMonth);
    final totalDays = _daysInMonth(_focusedMonth);
    final today = DateTime.now();

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calendario',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Gestión de turnos y eventos',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _goToToday,
                      icon: Icon(Icons.today_rounded, size: 18, color: AppColors.primaryTeal),
                      label: Text(
                        'Hoy',
                        style: TextStyle(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.history, color: AppColors.primaryTeal),
                        tooltip: 'Ver historial',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HistorialPage(registros: widget.registros),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_eventosError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'No se pudieron cargar eventos: $_eventosError',
                  style: TextStyle(color: AppColors.dangerRed, fontSize: 12),
                ),
              ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => _goToMonth(-1),
                          icon: Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary),
                          tooltip: 'Mes anterior',
                        ),
                      ),
                      Text(
                        monthLabel.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => _goToMonth(1),
                          icon: Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
                          tooltip: 'Mes siguiente',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
                        .map(
                          (day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 310,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, pageIndex) {
                        final int delta = pageIndex - _initialPage;
                        final DateTime baseMonth = _initialMonth();
                        final DateTime monthToRender = DateTime(baseMonth.year, baseMonth.month + delta, 1);
                        
                        final int totalDaysPage = _daysInMonth(monthToRender);
                        final int leadingEmptyPage = _leadingEmptyDays(monthToRender);

                        return GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                childAspectRatio: 1.05,
                              ),
                          itemCount: totalDaysPage + leadingEmptyPage,
                          itemBuilder: (context, index) {
                            if (index < leadingEmptyPage) return const SizedBox.shrink();
                            final day = index - leadingEmptyPage + 1;
                            final date = DateTime(monthToRender.year, monthToRender.month, day);
                            final isSelected = _selectedDay == day && _focusedMonth.month == monthToRender.month && _focusedMonth.year == monthToRender.year;
                            final isToday =
                                date.year == today.year && date.month == today.month && date.day == today.day;
                            final dots = _buildDotsForDay(date);

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDay = day;
                                  // Si pinchamos en un día del mes actual, nos cercioramos de que sea el mes en foco.
                                  if (monthToRender != _focusedMonth) {
                                     _pageController.animateToPage(pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOutCubic);
                                  }
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetallesDiaPage(
                                      fecha: date,
                                      registros: _registrosDelDia(date),
                                      eventos: _eventosDelDia(date),
                                    ),
                                  ),
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryTealLight
                                      : (isToday ? AppColors.primaryTealLight.withValues(alpha: 0.05) : Colors.transparent),
                                  borderRadius: BorderRadius.circular(16),
                                  border: isToday && !isSelected
                                      ? Border.all(color: AppColors.primaryTealLight.withValues(alpha: 0.5), width: 1.5)
                                      : Border.all(color: Colors.transparent),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryTealLight.withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$day',
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : (isToday ? FontWeight.bold : FontWeight.w500),
                                        color: isSelected ? AppColors.white : (isToday ? AppColors.primaryTealLight : AppColors.textPrimary),
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (dots.isNotEmpty) SizedBox(height: 4),
                                    if (dots.isNotEmpty)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: dots
                                            .map(
                                              (color) => Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                                                child: CircleAvatar(
                                                  radius: 3,
                                                  backgroundColor: color,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Center(
              child: Wrap(
                spacing: 8,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _LeyendaItem(color: AppColors.successGreen, label: 'Asistencia'),
                  _LeyendaItem(color: AppColors.dangerRed, label: 'Ausencia'),
                  _LeyendaItem(color: AppColors.warningOrange, label: 'Incidencia'),
                  _LeyendaItem(color: AppColors.primaryTealLight, label: 'Reunión'),
                ],
              ),
            ),

            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resumen Mensual',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  Icons.insert_chart_outlined_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryTealLight.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.how_to_reg_rounded,
                            color: AppColors.successGreen,
                            size: 26,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _asistenciasMes().toString(),
                          style: TextStyle(
                            fontSize: 32,
                            height: 1.0,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Asistencias',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.warningOrange.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.warningOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.warningOrange,
                            size: 26,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _incidenciasMes().toString(),
                          style: TextStyle(
                            fontSize: 32,
                            height: 1.0,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Incidencias',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LeyendaItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LeyendaItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class DetallesDiaPage extends StatelessWidget {
  final DateTime fecha;
  final List<RegistroHorario> registros;
  final List<CalendarioEventoRemote> eventos;

  const DetallesDiaPage({
    super.key,
    required this.fecha,
    required this.registros,
    required this.eventos,
  });

  String _hora(DateTime date) => DateFormat('HH:mm').format(date);

  @override
  Widget build(BuildContext context) {
    final fechaLabel = DateFormat('d MMMM yyyy', 'es_ES').format(fecha);
    final registrosOrdenados = [...registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
    final eventosOrdenados = [...eventos]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryTealLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detalles del $fechaLabel',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: registrosOrdenados.isEmpty && eventosOrdenados.isEmpty
            ? Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: AppColors.border),
                    SizedBox(height: 12),
                    Text(
                      'Sin registros',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'No hay movimientos registrados en este día.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (registrosOrdenados.isNotEmpty)
                    Column(
                      children: List.generate(registrosOrdenados.length, (index) {
                        final registro = registrosOrdenados[index];
                        final esEntrada = registro.tipo == TipoRegistro.entrada;
                        return _TimelineEventRow(
                          time: _hora(registro.fecha),
                          period: registro.fecha.hour >= 12 ? 'PM' : 'AM',
                          duration: '',
                          isLast: index == registrosOrdenados.length - 1,
                          card: _TimelineCard(
                            title: esEntrada ? 'Entrada' : 'Salida',
                            icon: esEntrada ? Icons.login_outlined : Icons.logout_outlined,
                            iconQuarter: esEntrada ? 0 : 2,
                            color: esEntrada ? AppColors.successGreen : AppColors.warningOrange,
                          ),
                        );
                      }),
                    ),
                  if (eventosOrdenados.isNotEmpty) ...[
                    if (registrosOrdenados.isNotEmpty) SizedBox(height: 12),
                    Text(
                      'Eventos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...eventosOrdenados.map(
                      (evento) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _eventColor(evento.tipo).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _eventIcon(evento.tipo),
                                color: _eventColor(evento.tipo),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    evento.titulo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if ((evento.descripcion ?? '').isNotEmpty)
                                    Text(
                                      evento.descripcion!,
                                      style: TextStyle(color: AppColors.textSecondary),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              evento.tipo,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Color _eventColor(String tipo) {
    switch (tipo) {
      case 'incidencia':
        return AppColors.warningOrange;
      case 'ausencia':
        return AppColors.dangerRed;
      case 'reunion':
        return AppColors.primaryTealLight;
      default:
        return AppColors.successGreen;
    }
  }

  IconData _eventIcon(String tipo) {
    switch (tipo) {
      case 'incidencia':
        return Icons.warning_amber_rounded;
      case 'ausencia':
        return Icons.event_busy;
      case 'reunion':
        return Icons.people_alt_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }
}

class _TimelineEventRow extends StatelessWidget {
  final String time;
  final String period;
  final String duration;
  final Widget card;
  final bool isLast;

  const _TimelineEventRow({
    required this.time,
    required this.period,
    required this.duration,
    required this.card,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left side: Time + Line
          SizedBox(
            width: 70,
            child: Column(
              children: [
                _TimelineTime(time: time, period: period, duration: duration),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.border,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 16),
          // Right side: The card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: card,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTime extends StatelessWidget {
  final String time;
  final String period;
  final String duration;

  const _TimelineTime({
    required this.time,
    required this.period,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          period,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        if (duration.isNotEmpty) ...[
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              duration,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? badgeText;
  final int iconQuarter;

  const _TimelineCard({
    required this.title,
    required this.icon,
    required this.color,
    this.badgeText,
    this.iconQuarter = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        RotatedBox(
                          quarterTurns: iconQuarter,
                          child: Icon(icon, color: color, size: 24),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (badgeText != null) ...[
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText!,
                          style: TextStyle(
                            color: color.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key, this.perfil});

  final PerfilUsuario? perfil;

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _notificaciones = true;
  bool _resumenDiario = false;

  void _mostrarSelectorTemas(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selecciona un Tema',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 24),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const _OpcionTema(
                            titulo: 'Océano (Predeterminado)',
                            codigoColor: Color(0xFF0284C7),
                            index: 0,
                          ),
                          SizedBox(height: 8),
                          const _OpcionTema(
                            titulo: 'Bosque (Verde Ecológico)',
                            codigoColor: Color(0xFF059669),
                            index: 2,
                          ),
                          SizedBox(height: 8),
                          const _OpcionTema(
                            titulo: 'Modo Oscuro (Clásico)',
                            codigoColor: Color(0xFF1E293B),
                            index: 3,
                          ),
                          SizedBox(height: 8),
                          const _OpcionTema(
                            titulo: 'Atardecer (Naranja Cálido)',
                            codigoColor: Color(0xFFEA580C),
                            index: 4,
                          ),
                          SizedBox(height: 8),
                          const _OpcionTema(
                            titulo: 'Lavanda (Morado Elegante)',
                            codigoColor: Color(0xFF9333EA),
                            index: 5,
                          ),
                          SizedBox(height: 8),
                          const _OpcionTema(
                            titulo: 'Medianoche (Azul Profundo)',
                            codigoColor: Color(0xFF38BDF8),
                            index: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final departamento = widget.perfil?.departamento ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 32,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.perfil?.nombreCompleto ?? 'Usuario de prácticas',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.perfil?.email ?? 'control.horario@empresa.com',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            departamento.isNotEmpty
                                ? departamento
                                : 'Sin departamento asignado',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Preferencias',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      value: _notificaciones,
                      onChanged: (value) {
                        setState(() => _notificaciones = value);
                      },
                      secondary: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.notifications_outlined, size: 24),
                      ),
                      title: Text(
                        'Notificaciones de fichaje',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Recibir recordatorios',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 20,
                      color: AppColors.border,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      value: _resumenDiario,
                      onChanged: (value) {
                        setState(() => _resumenDiario = value);
                      },
                      secondary: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.summarize_outlined, size: 24),
                      ),
                      title: Text(
                        'Resumen diario',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Enviar consolidado al final de jornada',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 20,
                      color: AppColors.border,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.palette_outlined, size: 24),
                      ),
                      title: Text(
                        'Tema visual',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Modifica los colores de la app',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => _mostrarSelectorTemas(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.logout,
                      color: AppColors.warningOrange,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.warningOrange,
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sesión cerrada correctamente'),
                        backgroundColor: AppColors.textPrimary,
                      ),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Versión base enfocada en control horario puro.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class ControlHorarioPage extends StatefulWidget {
  const ControlHorarioPage({
    required this.registros,
    required this.jornadaAbierta,
    required this.tiempoAcumulado,
    required this.onRegistrar,
    super.key,
  });

  final List<RegistroHorario> registros;
  final bool jornadaAbierta;
  final Duration tiempoAcumulado;
  final Future<void> Function(TipoRegistro) onRegistrar;

  @override
  State<ControlHorarioPage> createState() => _ControlHorarioPageState();
}

class _ControlHorarioPageState extends State<ControlHorarioPage> {
  late Timer _timer;
  late DateTime _ahora;

  @override
  void initState() {
    super.initState();
    _ahora = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _ahora = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int get _entradas => widget.registros
      .where((item) => item.tipo == TipoRegistro.entrada)
      .length;

  int get _salidas =>
      widget.registros.where((item) => item.tipo == TipoRegistro.salida).length;

  String _formatearDuracion(Duration duracion) {
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '${horas}h ${minutos}m';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("EEEE, d 'de' MMMM", 'es_ES');
    final timeFormat = DateFormat("HH:mm:ss");
    final shortTimeFormat = DateFormat("HH:mm");

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Panel de control',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.business_center,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Live Clock Card
            Card(
              color: widget.jornadaAbierta
                  ? AppColors.primaryTeal
                  : AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: widget.jornadaAbierta
                      ? Colors.transparent
                      : AppColors.border,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      dateFormat.format(_ahora).toUpperCase(),
                      style: TextStyle(
                        color: widget.jornadaAbierta
                            ? AppColors.white.withValues(alpha: 0.8)
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      timeFormat.format(_ahora),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -1,
                        color: widget.jornadaAbierta
                            ? AppColors.white
                            : AppColors.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: widget.jornadaAbierta
                            ? AppColors.white.withValues(alpha: 0.15)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.jornadaAbierta
                                ? Icons.play_circle_fill
                                : Icons.pause_circle_filled,
                            color: widget.jornadaAbierta
                                ? AppColors.successGreen
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            widget.jornadaAbierta
                                ? 'Jornada En Curso'
                                : 'Jornada Detenida',
                            style: TextStyle(
                              color: widget.jornadaAbierta
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.jornadaAbierta
                        ? null
                        : () => widget.onRegistrar(TipoRegistro.entrada),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      disabledBackgroundColor: AppColors.background,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.login,
                          size: 28,
                          color: widget.jornadaAbierta
                              ? AppColors.textSecondary.withValues(alpha: 0.5)
                              : AppColors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Entrada',
                          style: TextStyle(
                            color: widget.jornadaAbierta
                                ? AppColors.textSecondary.withValues(alpha: 0.5)
                                : AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.jornadaAbierta
                        ? () => widget.onRegistrar(TipoRegistro.salida)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warningOrange,
                      disabledBackgroundColor: AppColors.background,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.logout,
                          size: 28,
                          color: !widget.jornadaAbierta
                              ? AppColors.textSecondary.withValues(alpha: 0.5)
                              : AppColors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Salida',
                          style: TextStyle(
                            color: !widget.jornadaAbierta
                                ? AppColors.textSecondary.withValues(alpha: 0.5)
                                : AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Mini Dashboard Metrics
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Horas Hoy',
                    value: _formatearDuracion(widget.tiempoAcumulado),
                    color: AppColors.primaryTeal,
                    icon: Icons.timer,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: 'Fichajes',
                    value: (_entradas + _salidas).toString(),
                    color: AppColors.accentSky,
                    icon: Icons.sync_alt,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Recent Logs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Actividad Reciente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: Text('Ver todo')),
              ],
            ),
            SizedBox(height: 8),

            if (widget.registros.isEmpty)
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    'Aún no has registrado movimientos hoy.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.registros.length.clamp(0, 3),
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final registro = widget.registros[index];
                  final isEntry = registro.tipo == TipoRegistro.entrada;
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isEntry
                              ? AppColors.successGreen.withValues(alpha: 0.1)
                              : AppColors.warningOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isEntry ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isEntry
                              ? AppColors.successGreen
                              : AppColors.warningOrange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        isEntry ? 'Fichaje de Entrada' : 'Fichaje de Salida',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        dateFormat.format(registro.fecha),
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: Text(
                        shortTimeFormat.format(registro.fecha),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: AppColors.textSecondary)),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionTema extends StatelessWidget {
  final String titulo;
  final Color codigoColor;
  final int index;

  const _OpcionTema({
    required this.titulo,
    required this.codigoColor,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ControlHorarioApp.of(context).changeTheme(index);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.currentTheme == index
                ? AppColors.primaryTeal
                : AppColors.border,
          ),
          color: AppColors.currentTheme == index
              ? AppColors.primaryTeal.withValues(alpha: 0.05)
              : AppColors.surface,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(radius: 12, backgroundColor: codigoColor),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                titulo,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (AppColors.currentTheme == index)
              Icon(Icons.check_circle, color: AppColors.primaryTeal),
          ],
        ),
      ),
    );
  }
}
