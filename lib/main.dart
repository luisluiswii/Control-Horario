import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const ControlHorarioApp());
}

class AppColors {
  static const Color background = Color(0xFFF4F7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryTeal = Color(0xFF0F766E);
  static const Color primaryTealLight = Color(0xFF14B8A6);
  static const Color accentCoral = Color(0xFFFF6B6B);
  static const Color accentSky = Color(0xFF3B82F6);

  static const Color successGreen = Color(0xFF16A34A);
  static const Color warningOrange = Color(0xFFF59E0B);

  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryTeal,
          primary: AppColors.primaryTeal,
          secondary: AppColors.accentCoral,
          surface: AppColors.surface,
        ),
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTeal,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
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
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
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
            colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
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
  bool _remember = true;

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
                      child: Column(
                        children: [
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              prefixIcon: Icon(Icons.alternate_email),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
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
                              const Text('Mantener sesión iniciada'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const HomeShellPage(),
                                  ),
                                );
                              },
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ControlHorarioPage(),
      const PlaceholderPage(
        icon: Icons.calendar_today,
        title: 'Calendario',
        subtitle: 'Vista semanal y mensual de registros.',
      ),
      const PlaceholderPage(
        icon: Icons.history,
        title: 'Historial',
        subtitle: 'Consulta tus fichajes anteriores.',
      ),
      const PlaceholderPage(
        icon: Icons.person,
        title: 'Perfil',
        subtitle: 'Datos de usuario y preferencias.',
      ),
    ];

    return Scaffold(
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
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendario',
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

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64, color: AppColors.primaryTeal),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 18),
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                  label: const Text('Personalizar módulo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControlHorarioPage extends StatefulWidget {
  const ControlHorarioPage({super.key});

  @override
  State<ControlHorarioPage> createState() => _ControlHorarioPageState();
}

class _ControlHorarioPageState extends State<ControlHorarioPage> {
  final List<RegistroHorario> _registros = [];

  int get _entradas =>
      _registros.where((item) => item.tipo == TipoRegistro.entrada).length;

  int get _salidas =>
      _registros.where((item) => item.tipo == TipoRegistro.salida).length;

  void _registrar(TipoRegistro tipo) {
    setState(() {
      _registros.insert(0, RegistroHorario(tipo: tipo, fecha: DateTime.now()));
    });
  }

  String _hora(DateTime fecha) {
    final horas = fecha.hour.toString().padLeft(2, '0');
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final segundos = fecha.second.toString().padLeft(2, '0');
    return '$horas:$minutos:$segundos';
  }

  String _fecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Panel de fichaje',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Registra tus entradas y salidas del día',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Entradas',
                    value: _entradas.toString(),
                    color: AppColors.successGreen,
                    icon: Icons.login,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    label: 'Salidas',
                    value: _salidas.toString(),
                    color: AppColors.warningOrange,
                    icon: Icons.logout,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hoy: ${_fecha(ahora)}'),
                    const SizedBox(height: 4),
                    Text(
                      'Hora actual: ${_hora(ahora)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _registrar(TipoRegistro.entrada),
                    icon: const Icon(Icons.login),
                    label: const Text('Registrar entrada'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _registrar(TipoRegistro.salida),
                    icon: const Icon(Icons.logout),
                    label: const Text('Registrar salida'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Registros de hoy',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _registros.isEmpty
                  ? const Center(child: Text('Sin registros todavía'))
                  : ListView.separated(
                      itemCount: _registros.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final registro = _registros[index];
                        final esEntrada = registro.tipo == TipoRegistro.entrada;
                        return ListTile(
                          leading: Icon(
                            esEntrada ? Icons.login : Icons.logout,
                            color: esEntrada ? Colors.green : Colors.orange,
                          ),
                          title: Text(esEntrada ? 'Entrada' : 'Salida'),
                          subtitle: Text(_fecha(registro.fecha)),
                          trailing: Text(_hora(registro.fecha)),
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
                Text(label, style: const TextStyle(color: AppColors.textSecondary)),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
