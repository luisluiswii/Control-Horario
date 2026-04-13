import 'package:flutter/material.dart';
import 'main.dart';

class TablonPage extends StatelessWidget {
  const TablonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Comunicaci\u00f3n Interna',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryTealLight),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildNewsCard(
            '\u00a1Nueva pol\u00edtica de Teletrabajo!',
            'Recursos Humanos',
            'Hace 2 horas',
            'Se han actualizado los l\u00edmites de teletrabajo a 3 d\u00edas semanales para todos los empleados de oficinas centrales.',
            isPinned: true,
          ),
          _buildNewsCard(
            'Cierre viernes a las 15:00',
            'Direcci\u00f3n',
            'Hace 1 d\u00eda',
            'Este viernes, debido a las festividades locales, la oficina cerrar\u00e1 sus puertas a las 15:00 hrs. \u00a1Disfruten!',
          ),
          _buildNewsCard(
            'Actualizaci\u00f3n de Seguridad',
            'Depto. IT',
            'Hace 4 d\u00edas',
            'Por favor, recuerden actualizar sus contrase\u00f1as de los servidores internos antes del pr\u00f3ximo mi\u00e9rcoles por protocolo anual.',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(
    String title,
    String author,
    String time,
    String content, {
    bool isPinned = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPinned
            ? AppColors.primaryTealLight.withValues(alpha: 0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPinned ? AppColors.primaryTealLight : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.campaign,
                    color: isPinned
                        ? AppColors.primaryTealLight
                        : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    author,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                time,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (isPinned) ...[
                Icon(Icons.push_pin, color: AppColors.warningOrange, size: 16),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
