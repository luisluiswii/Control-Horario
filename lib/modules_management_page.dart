import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

// Singleton que guarda qué módulos están activos
class ModulesManager {
  static final ModulesManager _instance = ModulesManager._internal();
  factory ModulesManager() => _instance;
  ModulesManager._internal();

  // ───────────────────────────────────────────────────────────────────────────
  // PERFIL: PELUQUERÍA (4 PERSONAS)
  // Mantener este mapa sincronizado con `menuItems` de `main.dart`. Los
  // módulos comentados aquí se ocultan también del panel "Gestionar módulos"
  // para no confundir al administrador con opciones que no aplican.
  // NO BORRAR las líneas comentadas: las otras empresas del proyecto las
  // necesitan. Ver `docs/PELUQUERIA.md`.
  // ───────────────────────────────────────────────────────────────────────────
  final Map<String, bool> _activos = {
    'Vacaciones': true,
    'Nóminas': true,
    // 'Aprobaciones': true, // [peluquería] desactivado
    'Tablón': true,
    'Añadir tareas': true,
    'Documentos': true,
    // 'Encuesta 360°': true, // [peluquería] desactivado
    'Gestión': true,
    'Cambiar turno': true,
    'Trabajadores': true,
    // 'Cursos': true, // [peluquería] desactivado
    // 'Asistencias': true, // [peluquería] desactivado
    // 'Asistencia App': true, // [peluquería] desactivado
    'Quejas': true,
  };

  Future<void> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _activos.keys) {
      _activos[key] = prefs.getBool('modulo_$key') ?? true;
    }
  }

  Future<void> guardar() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in _activos.entries) {
      await prefs.setBool('modulo_${entry.key}', entry.value);
    }
  }

  bool isActive(String nombre) => _activos[nombre] ?? true;

  void toggle(String nombre) {
    _activos[nombre] = !(_activos[nombre] ?? true);
  }

  Map<String, bool> get all => Map.unmodifiable(_activos);
}

class ModulesManagementPage extends StatefulWidget {
  const ModulesManagementPage({super.key});

  @override
  State<ModulesManagementPage> createState() => _ModulesManagementPageState();
}

class _ModulesManagementPageState extends State<ModulesManagementPage> {
  final ModulesManager _manager = ModulesManager();

  // [peluquería] iconos sincronizados con `_activos`: las entradas comentadas
  // arriba también van comentadas aquí. Ver `docs/PELUQUERIA.md`.
  final Map<String, IconData> _iconos = {
    'Vacaciones': Icons.flight_takeoff,
    'Nóminas': Icons.account_balance_wallet,
    // 'Aprobaciones': Icons.fact_check, // [peluquería] desactivado
    'Tablón': Icons.campaign,
    'Añadir tareas': Icons.add_task,
    'Documentos': Icons.description_outlined,
    // 'Encuesta 360°': Icons.view_in_ar_outlined, // [peluquería] desactivado
    'Gestión': Icons.settings_outlined,
    'Cambiar turno': Icons.swap_horiz,
    'Trabajadores': Icons.people_outline,
    // 'Cursos': Icons.school_outlined, // [peluquería] desactivado
    // 'Asistencias': Icons.headset_mic_outlined, // [peluquería] desactivado
    // 'Asistencia App': Icons.help_outline, // [peluquería] desactivado
    'Quejas': Icons.chat_bubble_outline,
  };

  @override
  Widget build(BuildContext context) {
    final modulos = _manager.all;
    final activosCount = modulos.values.where((v) => v).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gestionar módulos'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryTealLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.primaryTealLight),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: AppColors.primaryTealLight.withValues(alpha: 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.admin_panel_settings,
                        color: AppColors.primaryTealLight, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Panel de administrador',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTealLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Activa o desactiva los botones que aparecen en el menú principal.',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  '$activosCount de ${modulos.length} módulos activos',
                  style: TextStyle(
                    color: AppColors.primaryTealLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: modulos.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, indent: 72, color: AppColors.border),
              itemBuilder: (context, index) {
                final nombre = modulos.keys.elementAt(index);
                final activo = modulos[nombre]!;
                final icono = _iconos[nombre] ?? Icons.widgets_outlined;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 6),
                  leading: CircleAvatar(
                    backgroundColor: activo
                        ? AppColors.primaryTealLight.withValues(alpha: 0.12)
                        : AppColors.border.withValues(alpha: 0.5),
                    child: Icon(
                      icono,
                      color: activo
                          ? AppColors.primaryTealLight
                          : AppColors.textSecondary.withValues(alpha: 0.5),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: activo
                          ? AppColors.textPrimary
                          : AppColors.textSecondary.withValues(alpha: 0.5),
                      decoration: activo
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
                  trailing: Switch.adaptive(
                    value: activo,
                    activeColor: AppColors.primaryTealLight,
                    onChanged: (_) {
                      setState(() => _manager.toggle(nombre));
                    },
                  ),
                  onTap: () => setState(() => _manager.toggle(nombre)),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              await _manager.guardar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cambios guardados'),
                  backgroundColor: AppColors.successGreen,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Guardar cambios',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}