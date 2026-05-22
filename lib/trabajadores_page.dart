import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registro_page.dart';
import 'main.dart';

class TrabajadoresPage extends StatefulWidget {
  const TrabajadoresPage({super.key});

  @override
  State<TrabajadoresPage> createState() => _TrabajadoresPageState();
}

class _TrabajadoresPageState extends State<TrabajadoresPage> {
  List<Map<String, dynamic>> trabajadores = [];
  List<Map<String, dynamic>> filtrados = [];
  bool cargando = true;
  bool eliminando = false;
  Set<int> usuariosEliminados = {}; // Usuarios "eliminados" localmente

  final TextEditingController searchController = TextEditingController();

  String? currentAuthId;

  @override
  void initState() {
    super.initState();
    currentAuthId = Supabase.instance.client.auth.currentUser?.id;
    cargarUsuariosEliminados();
    cargarTrabajadores();
  }

  // 💾 Cargar usuarios eliminados del almacenamiento local
  Future<void> cargarUsuariosEliminados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eliminadosJson = prefs.getStringList('usuarios_eliminados') ?? [];

      setState(() {
        usuariosEliminados = eliminadosJson.map((id) => int.parse(id)).toSet();
      });

      print('✅ Usuarios eliminados cargados: $usuariosEliminados');
    } catch (e) {
      print('Error cargando usuarios eliminados: $e');
    }
  }

  // 💾 Guardar usuarios eliminados en almacenamiento local
  Future<void> guardarUsuariosEliminados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eliminadosJson =
      usuariosEliminados.map((id) => id.toString()).toList();
      await prefs.setStringList('usuarios_eliminados', eliminadosJson);

      print('✅ Usuarios eliminados guardados: $eliminadosJson');
    } catch (e) {
      print('Error guardando usuarios eliminados: $e');
    }
  }

  Future<void> cargarTrabajadores() async {
    try {
      final data = await Supabase.instance.client
          .from('usuario')
          .select('id_usuario, nombre_completo, rol, auth_user_id')
          .eq('activo', true)
          .isFilter('deleted_at', null);

      // Filtrar el usuario actual Y los usuarios eliminados localmente
      final listaFiltrada = data.where((t) {
        return t['auth_user_id'] != currentAuthId &&
            !usuariosEliminados.contains(t['id_usuario']);
      }).toList();

      setState(() {
        trabajadores = List<Map<String, dynamic>>.from(listaFiltrada);
        filtrados = trabajadores;
        cargando = false;
      });

      print('✅ Trabajadores cargados: ${trabajadores.length}');
    } catch (e) {
      print('Error cargando trabajadores: $e');
      setState(() => cargando = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar trabajadores: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> eliminarTrabajador(int idUsuario, String nombreTrabajador) async {
    setState(() => eliminando = true);

    try {
      // ✅ Agregar a la lista de eliminados LOCALMENTE
      setState(() {
        usuariosEliminados.add(idUsuario);
        trabajadores.removeWhere((t) => t['id_usuario'] == idUsuario);
        filtrados.removeWhere((t) => t['id_usuario'] == idUsuario);
      });

      // ✅ Guardar en almacenamiento local
      await guardarUsuariosEliminados();

      setState(() => eliminando = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$nombreTrabajador ha sido eliminado'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      print('✅ Trabajador $nombreTrabajador eliminado localmente');
    } catch (e) {
      setState(() => eliminando = false);

      print("❌ Error eliminando trabajador: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // 🔄 Restaurar un usuario (opcional)
  Future<void> restaurarTrabajador(int idUsuario, String nombreTrabajador) async {
    setState(() {
      usuariosEliminados.remove(idUsuario);
    });

    await guardarUsuariosEliminados();
    await cargarTrabajadores();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$nombreTrabajador ha sido restaurado'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lista = searchController.text.isEmpty ? trabajadores : filtrados;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Directorio de Empleados',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RegistroPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 BARRA DE BÚSQUEDA
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.primaryTeal,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filtrados = trabajadores.where((t) {
                    final nombre = t['nombre_completo'].toLowerCase();
                    return nombre.contains(value.toLowerCase());
                  }).toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar compañero...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          if (cargando)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (lista.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No hay trabajadores registrados.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  final worker = lista[index];

                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.primaryTealLight,
                          child: Text(
                            worker['nombre_completo']!.substring(0, 1),
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        title: Text(
                          worker['nombre_completo'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          worker['rol'] ?? '',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        // 🗑️ PAPELERA
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: eliminando
                                ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                  Colors.red.shade400,
                                ),
                              ),
                            )
                                : const Icon(Icons.delete, color: Colors.red),
                            onPressed: eliminando
                                ? null
                                : () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Eliminar trabajador"),
                                  content: Text(
                                    "¿Seguro que quieres eliminar a ${worker['nombre_completo']}? Esta acción es permanente.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        eliminarTrabajador(
                                          worker['id_usuario'],
                                          worker['nombre_completo'],
                                        );
                                      },
                                      child: const Text(
                                        "Eliminar",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}