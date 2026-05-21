import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'supabase_app_repository.dart';

class CrearTrabajadorPage extends StatefulWidget {
  const CrearTrabajadorPage({super.key});

  @override
  State<CrearTrabajadorPage> createState() => _CrearTrabajadorPageState();
}

class _CrearTrabajadorPageState extends State<CrearTrabajadorPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nombreController = TextEditingController();
  final _identificacionController = TextEditingController();
  final _passwordController = TextEditingController(
    text: generarPasswordTemporal(),
  );
  String? _departamento;
  bool _enviando = false;

  final List<String> _departamentos = const [
    'Recursos Humanos',
    'Desarrollo / IT',
    'Marketing',
    'Ventas',
    'Administración',
    'Operaciones',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _nombreController.dispose();
    _identificacionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _regenerarPassword() {
    setState(() => _passwordController.text = generarPasswordTemporal());
  }

  Future<void> _copiarPassword() async {
    await Clipboard.setData(ClipboardData(text: _passwordController.text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contraseña copiada al portapapeles')),
    );
  }

  Future<void> _crear() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _enviando = true);
    try {
      await SupabaseAppRepository.crearTrabajador(
        email: _emailController.text.trim().toLowerCase(),
        passwordTemporal: _passwordController.text,
        nombreCompleto: _nombreController.text.trim(),
        departamento: _departamento ?? '',
        identificacion: _identificacionController.text.trim(),
      );
      if (!mounted) return;
      await _mostrarResumen();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _mostrarResumen() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Trabajador creado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Comparte estas credenciales con el trabajador. '
                'Se le pedirá cambiar la contraseña al iniciar sesión.'),
            const SizedBox(height: 16),
            SelectableText('Email: ${_emailController.text.trim().toLowerCase()}'),
            SelectableText('Contraseña: ${_passwordController.text}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo trabajador')),
      body: AbsorbPointer(
        absorbing: _enviando,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Alta de empleado',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Se creará la cuenta con una contraseña temporal. '
                        'El trabajador deberá cambiarla en su primer acceso.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => (v ?? '').trim().isEmpty
                            ? 'Indica el nombre'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (v) {
                          final s = (v ?? '').trim();
                          if (s.isEmpty) return 'Indica el correo';
                          if (!s.contains('@')) return 'Correo inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _departamento,
                        decoration: const InputDecoration(
                          labelText: 'Departamento',
                          prefixIcon: Icon(Icons.domain),
                        ),
                        items: _departamentos
                            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (v) => setState(() => _departamento = v),
                        validator: (v) =>
                            v == null ? 'Selecciona un departamento' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _identificacionController,
                        decoration: const InputDecoration(
                          labelText: 'ID de empleado (opcional)',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña temporal',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Generar otra',
                                onPressed: _regenerarPassword,
                                icon: const Icon(Icons.refresh),
                              ),
                              IconButton(
                                tooltip: 'Copiar',
                                onPressed: _copiarPassword,
                                icon: const Icon(Icons.copy),
                              ),
                            ],
                          ),
                        ),
                        validator: (v) => (v ?? '').length < 8
                            ? 'Mínimo 8 caracteres'
                            : null,
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        onPressed: _enviando ? null : _crear,
                        icon: _enviando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(_enviando ? 'Creando...' : 'Crear cuenta'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
