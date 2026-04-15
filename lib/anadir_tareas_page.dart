import 'package:flutter/material.dart';
import 'main.dart'; // Para acceder a AppColors

class AnadirTareasPage extends StatefulWidget {
  const AnadirTareasPage({super.key});

  @override
  State<AnadirTareasPage> createState() => AnadirTareasPageState();
}

class AnadirTareasPageState extends State<AnadirTareasPage> {
  final List<Map<String, dynamic>> _tareas = [
    {'titulo': 'Completar reporte semanal', 'completada': false},
    {'titulo': 'Revisar correos del equipo', 'completada': false},
    {'titulo': 'Planificar reunión de mañana', 'completada': true},
  ];

  void _agregarTarea() {
    String nuevaTarea = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Nueva Tarea',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            autofocus: true,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: '¿Qué necesitas hacer?',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryTealLight,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              nuevaTarea = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                if (nuevaTarea.trim().isNotEmpty) {
                  setState(() {
                    _tareas.insert(0, {
                      'titulo': nuevaTarea.trim(),
                      'completada': false,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Añadir Tareas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: _tareas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_outlined, size: 80, color: AppColors.border),
                  const SizedBox(height: 16),
                  Text(
                    'No hay tareas pendientes',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      title: Text(
                        tarea['titulo'],
                        style: TextStyle(
                          color: tarea['completada']
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          decoration: tarea['completada']
                              ? TextDecoration.lineThrough
                              : null,
                          fontWeight: tarea['completada']
                              ? FontWeight.normal
                              : FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      leading: Checkbox(
                        value: tarea['completada'],
                        activeColor: AppColors.successGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: BorderSide(
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            _tareas[index]['completada'] = value ?? false;
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.dangerRed.withValues(alpha: 0.8),
                        ),
                        onPressed: () {
                          setState(() {
                            _tareas.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarTarea,
        backgroundColor: AppColors.primaryTealLight,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.add, color: AppColors.white, size: 30),
      ),
    );
  }
}
