import 'package:flutter/material.dart';
import 'main.dart';

class EncuestaPage extends StatelessWidget {
  final List<Map<String, dynamic>> evaluaciones = [
    {
      'titulo': 'Evaluación de Desempeño Q1',
      'fecha': 'Termina el 30 Mar',
      'estado': 'Pendiente',
      'progreso': 0.0,
    },
    {
      'titulo': 'Clima Laboral 2026',
      'fecha': 'Termina el 15 Abr',
      'estado': 'En progreso',
      'progreso': 0.4,
    },
    {
      'titulo': 'Autoevaluación Anual',
      'fecha': 'Completada el 10 Ene',
      'estado': 'Completado',
      'progreso': 1.0,
    },
  ];

  EncuestaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Encuesta 360°',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tus Evaluaciones',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'El feedback constructivo ayuda al crecimiento de todos.',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: evaluaciones.length,
              itemBuilder: (context, index) {
                final eval = evaluaciones[index];
                bool completado = eval['estado'] == 'Completado';

                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                eval['titulo'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              completado
                                  ? Icons.check_circle
                                  : Icons.pending_actions,
                              color: completado
                                  ? AppColors.successGreen
                                  : AppColors.warningOrange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          eval['fecha'],
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: eval['progreso'],
                          backgroundColor: AppColors.border,
                          color: completado
                              ? AppColors.successGreen
                              : AppColors.warningOrange,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: completado
                                  ? AppColors.border
                                  : AppColors.primaryTealLight,
                              foregroundColor: completado
                                  ? AppColors.textSecondary
                                  : AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              completado
                                  ? 'Ver Resultados'
                                  : (eval['progreso'] > 0
                                        ? 'Continuar'
                                        : 'Comenzar'),
                            ),
                          ),
                        ),
                      ],
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
}
