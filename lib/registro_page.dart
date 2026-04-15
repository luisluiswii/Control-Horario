import 'package:flutter/material.dart';
import 'main.dart'; // Para reutilizar AppColors

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _identificacionController = TextEditingController();

  String? _departamentoSeleccionado;
  final List<String> _departamentos = [
    'Recursos Humanos',
    'Desarrollo / IT',
    'Marketing',
    'Ventas',
    'Administración',
    'Operaciones',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _identificacionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Simular registro exitoso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registro exitoso. Iniciando sesión...'),
        backgroundColor: AppColors.successGreen,
      ),
    );

    // Navegar de vuelta al Home (o al Login dependiendo del flujo que desees)
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShellPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
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
                      ClipOval(
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          width: 70,
                          height: 70,
                          color: AppColors.primaryTealLight,
                          colorBlendMode: BlendMode.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Únete a Nosotros',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completa tu perfil corporativo para acceder al panel de control de horas.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if ((value?.trim() ?? '').isEmpty) {
                            return 'Ingresa tu nombre.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
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
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _identificacionController,
                        decoration: const InputDecoration(
                          labelText: 'ID de Empleado (Opcional)',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Departamento',
                          prefixIcon: Icon(Icons.domain),
                        ),
                        initialValue: _departamentoSeleccionado,
                        items: _departamentos.map((String depto) {
                          return DropdownMenuItem<String>(
                            value: depto,
                            child: Text(depto),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _departamentoSeleccionado = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Selecciona un área' : null,
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
                          if ((value ?? '').length < 6) {
                            return 'Debe tener al menos 6 caracteres.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Confirma tu contraseña.';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.person_add),
                          label: const Text('Registrarse'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '¿Ya tienes cuenta? Inicia sesión aquí',
                          style: TextStyle(color: AppColors.primaryTealLight),
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
    );
  }
}
