import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/gestures.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const ControlHorarioApp());
}

class AppColors {
  static const Color background = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryTeal = Color(
    0xFF0F172A,
  ); // Very dark slate (modern professional)
  static const Color primaryTealLight = Color(0xFF334155);
  static const Color accentCoral = Color(0xFF3B82F6); // Professional blue
  static const Color accentSky = Color(0xFF60A5FA);

  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color dangerRed = Color(0xFFEF4444);

  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class ControlHorarioApp extends StatelessWidget {
  const ControlHorarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Horario',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSeed(
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
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTeal,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
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
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryTeal,
              width: 2,
            ),
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

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryTeal, AppColors.primaryTealLight],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    width: 114,
                    height: 114,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Control Horario',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Registro simple, claro y rápido',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ),
                ],
              ),
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

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShellPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 36),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryTeal, AppColors.primaryTealLight],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola,',
                  style: TextStyle(fontSize: 22, color: AppColors.white),
                ),
                SizedBox(height: 6),
                Text(
                  'Inicia sesión para continuar',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primaryTeal,
                                    AppColors.primaryTealLight,
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.fingerprint,
                                color: AppColors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Acceso seguro',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.alternate_email),
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
                            const SizedBox(height: 14),
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
                            const SizedBox(height: 8),
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
                                  child: const Text('¿Olvidaste tu clave?'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _submit,
                                icon: const Icon(Icons.login),
                                label: const Text('Acceder al panel'),
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _jornadaAbierta {
    if (_registros.isEmpty) return false;
    return _registros.first.tipo == TipoRegistro.entrada;
  }

  int get _entradas =>
      _registros.where((item) => item.tipo == TipoRegistro.entrada).length;

  int get _salidas =>
      _registros.where((item) => item.tipo == TipoRegistro.salida).length;

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

  void _registrar(TipoRegistro tipo) {
    setState(() {
      _registros.insert(0, RegistroHorario(tipo: tipo, fecha: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ControlHorarioPage(
        registros: _registros,
        jornadaAbierta: _jornadaAbierta,
        tiempoAcumulado: _tiempoAcumulado,
        onRegistrar: _registrar,
      ),
      JornadaResumenPage(
        jornadaAbierta: _jornadaAbierta,
        entradas: _entradas,
        salidas: _salidas,
        tiempoAcumulado: _tiempoAcumulado,
        onRegistrar: _registrar,
      ),
      HistorialPage(registros: _registros),
      const PerfilPage(),
    ];

    final titles = ['Inicio', 'Jornadas', 'Historial', 'Perfil'];

    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: AppColors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Jornadas',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_toggle_off),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
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
  final ValueChanged<TipoRegistro> onRegistrar;

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estado de jornada',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                        const SizedBox(width: 8),
                        Text(
                          jornadaAbierta
                              ? 'Jornada activa (pendiente de salida)'
                              : 'Sin jornada activa',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tiempo acumulado',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        Text(
                          _formatearDuracion(tiempoAcumulado),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: progreso,
                        backgroundColor: AppColors.background,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        jornadaAbierta
                            ? 'Salida estimada para completar 8h: ${_hora(salidaEstimada)}'
                            : 'Meta de jornada diaria: 8h de trabajo efectivo',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                const SizedBox(width: 10),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: jornadaAbierta
                        ? null
                        : () => onRegistrar(TipoRegistro.entrada),
                    icon: const Icon(Icons.login),
                    label: const Text('Iniciar jornada'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: jornadaAbierta
                        ? () => onRegistrar(TipoRegistro.salida)
                        : null,
                    icon: const Icon(Icons.logout),
                    label: const Text('Finalizar jornada'),
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Movimientos registrados',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.registros.length} fichaje(s) totales',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(opciones.length, (index) {
                        return ChoiceChip(
                          label: Text(opciones[index]),
                          selected: _filtro == index,
                          onSelected: (_) => setState(() => _filtro = index),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: registrosFiltrados.isEmpty
                  ? Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.history,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'No hay resultados para este filtro',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Prueba otro filtro o registra nuevos movimientos.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: registrosFiltrados.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final registro = registrosFiltrados[index];
                        final esEntrada = registro.tipo == TipoRegistro.entrada;
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  (esEntrada
                                          ? AppColors.successGreen
                                          : AppColors.warningOrange)
                                      .withValues(alpha: 0.14),
                              child: Icon(
                                esEntrada ? Icons.login : Icons.logout,
                                color: esEntrada
                                    ? AppColors.successGreen
                                    : AppColors.warningOrange,
                              ),
                            ),
                            title: Text(
                              esEntrada
                                  ? 'Entrada registrada'
                                  : 'Salida registrada',
                            ),
                            subtitle: Text(_fecha(registro.fecha)),
                            trailing: Text(
                              _hora(registro.fecha),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
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
    );
  }
}

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _notificaciones = true;
  bool _resumenDiario = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primaryTeal,
                      child: Icon(Icons.person, color: AppColors.white),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuario de prácticas',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'control.horario@empresa.com',
                            style: TextStyle(color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: _notificaciones,
                    onChanged: (value) {
                      setState(() => _notificaciones = value);
                    },
                    secondary: const Icon(Icons.notifications_none),
                    title: const Text('Notificaciones de fichaje'),
                    subtitle: const Text(
                      'Recibir recordatorios de entrada/salida',
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _resumenDiario,
                    onChanged: (value) {
                      setState(() => _resumenDiario = value);
                    },
                    secondary: const Icon(Icons.summarize_outlined),
                    title: const Text('Resumen diario automático'),
                    subtitle: const Text(
                      'Enviar consolidado al final de jornada',
                    ),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.palette_outlined),
                    title: Text('Tema visual'),
                    subtitle: Text(
                      'Base neutra para futuros forks por empresa',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Versión base enfocada en control horario puro.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
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
  final ValueChanged<TipoRegistro> onRegistrar;

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
        padding: const EdgeInsets.all(20),
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
                    const Text(
                      'Resumen',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
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
                  child: const Icon(
                    Icons.business_center,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

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
                padding: const EdgeInsets.all(24),
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
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
                          const SizedBox(width: 8),
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
            const SizedBox(height: 24),

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
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
                        const SizedBox(height: 8),
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
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.jornadaAbierta
                        ? () => widget.onRegistrar(TipoRegistro.salida)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warningOrange,
                      disabledBackgroundColor: AppColors.background,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
                        const SizedBox(height: 8),
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
            const SizedBox(height: 24),

            // Mini Dashboard Metrics
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Horas Hoy',
                    value: _formatearDuracion(widget.tiempoAcumulado),
                    color: AppColors.accentCoral,
                    icon: Icons.timer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: 'Fichajes',
                    value: (_entradas + _salidas).toString(),
                    color: AppColors.primaryTeal.withValues(alpha: 0.8),
                    icon: Icons.sync_alt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Logs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Actividad Reciente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('Ver todo')),
              ],
            ),
            const SizedBox(height: 8),

            if (widget.registros.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
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
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
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
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        dateFormat.format(registro.fecha),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: Text(
                        shortTimeFormat.format(registro.fecha),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
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
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
