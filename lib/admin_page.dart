import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart';
import 'supabase_app_repository.dart';

/// Pantalla de inicio del rol administrador. Muestra el listado de
/// empleados activos. Las acciones avanzadas (creación de cuentas,
/// gestión de turnos, etc.) se incorporarán a medida que el equipo las
/// vaya integrando.
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<PerfilUsuario> _empleados = const [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  Future<void> _cargarEmpleados() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final lista = await SupabaseAppRepository.loadActiveEmployees();
      if (!mounted) return;
      setState(() {
        _empleados = lista;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  Future<void> _cerrarSesion() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            tooltip: 'Refrescar',
            onPressed: _cargarEmpleados,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.dangerRed),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cargarEmpleados,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    if (_empleados.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline,
                  size: 56, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              const Text('Todavía no hay trabajadores dados de alta.'),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargarEmpleados,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _empleados.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final emp = _empleados[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: emp.esAdmin
                    ? AppColors.primaryTeal
                    : AppColors.primaryTealLight,
                child: Icon(
                  emp.esAdmin ? Icons.shield : Icons.person,
                  color: AppColors.white,
                ),
              ),
              title: Text(emp.nombreCompleto.isEmpty
                  ? emp.email
                  : emp.nombreCompleto),
              subtitle: Text(
                '${emp.email}\n${emp.departamento.isEmpty ? "—" : emp.departamento}'
                ' · ${emp.rol}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
