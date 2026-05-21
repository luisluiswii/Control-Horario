import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart';
import 'supabase_app_repository.dart';

/// Pantalla bloqueante que se muestra al trabajador en su primer login
/// (cuando `usuario.must_change_password = true`). Hasta que no cambia la
/// contraseña, no puede usar la app.
class CambiarPasswordInicialPage extends StatefulWidget {
  const CambiarPasswordInicialPage({super.key, required this.destino});

  /// Página a la que navegar una vez cambiada la contraseña (el shell
  /// correspondiente al rol del usuario).
  final Widget destino;

  @override
  State<CambiarPasswordInicialPage> createState() =>
      _CambiarPasswordInicialPageState();
}

class _CambiarPasswordInicialPageState
    extends State<CambiarPasswordInicialPage> {
  final _formKey = GlobalKey<FormState>();
  final _nuevaController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _nuevaController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _enviando = true);
    try {
      await SupabaseAppRepository.aplicarCambioPasswordInicial(
        _nuevaController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => widget.destino),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo cambiar la contraseña: $e'),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _cancelar() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.lock_reset,
                              size: 48, color: AppColors.primaryTeal),
                          const SizedBox(height: 12),
                          Text(
                            'Cambia tu contraseña',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Antes de continuar debes establecer una contraseña '
                            'personal. La que te facilitaron es temporal.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 22),
                          TextFormField(
                            controller: _nuevaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Nueva contraseña',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (v) {
                              if ((v ?? '').length < 8) {
                                return 'Mínimo 8 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirmar contraseña',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (v) {
                              if ((v ?? '') != _nuevaController.text) {
                                return 'No coincide con la nueva contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 22),
                          ElevatedButton.icon(
                            onPressed: _enviando ? null : _confirmar,
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
                            label: Text(
                              _enviando ? 'Guardando...' : 'Guardar y continuar',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _enviando ? null : _cancelar,
                            child: const Text('Cerrar sesión'),
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
      ),
    );
  }
}
