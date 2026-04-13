import 'package:flutter/material.dart';
import 'main.dart';

class AsistenciasPage extends StatelessWidget {
  final List<Map<String, String>> registros = [
    {
      'fecha': 'Hoy',
      'tipo': 'Retraso',
      'tiempo': '15 minutos',
      'estado': 'Pendiente',
    },
    {
      'fecha': '12 Mar 2026',
      'tipo': 'Falta injustificada',
      'tiempo': 'Día completo',
      'estado': 'Pendiente',
    },
    {
      'fecha': '05 Mar 2026',
      'tipo': 'Falta por enfermedad',
      'tiempo': 'Día completo',
      'estado': 'Justificado',
    },
  ];

  AsistenciasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Resolver Faltas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.surface,
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.warningOrange,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Tienes 2 incidencias pendientes de justificar. Evita penalizaciones subiendo tus justificantes.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final reg = registros[index];
                bool isPendiente = reg['estado'] == 'Pendiente';
                Color estadoColor = isPendiente
                    ? AppColors.dangerRed
                    : AppColors.successGreen;

                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              reg['fecha']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: estadoColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                reg['estado']!,
                                style: TextStyle(
                                  color: estadoColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tipo: ${reg['tipo']} (${reg['tiempo']})',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        if (isPendiente) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.upload_file,
                                  size: 18,
                                  color: AppColors.primaryTealLight,
                                ),
                                label: Text(
                                  'Adjuntar justificación',
                                  style: TextStyle(
                                    color: AppColors.primaryTealLight,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: AppColors.primaryTealLight,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
