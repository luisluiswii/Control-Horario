import 'package:flutter/material.dart';
import 'main.dart';

class AsistenciaAppPage extends StatelessWidget {
  const AsistenciaAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Asistencia',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _FaqItem(
            pregunta: '¿Cómo ficho mi entrada/salida?',
            respuesta:
                'En la pestaña "Inicio", pulsa el botón grande de "Registrar Entrada". Cuando termines tu jornada, el botón cambiará a "Registrar Salida".',
          ),
          _FaqItem(
            pregunta: '¿Dónde veo mis horas trabajadas?',
            respuesta:
                'Puedes ver un resumen de tus horas en la pestaña "Inicio", en las tarjetas de "Hoy" y "Semana". Para un registro detallado, ve a la pestaña "Calendario" y selecciona un día.',
          ),
          _FaqItem(
            pregunta: '¿Cómo solicito un cambio de turno?',
            respuesta:
                'Ve a "Menú" > "Cambiar Turno". Desde allí podrás seleccionar tu turno actual y proponer un cambio a un compañero.',
          ),
          _FaqItem(
            pregunta: '¿Es posible corregir un fichaje erróneo?',
            respuesta:
                'Sí, en la pestaña "Calendario", selecciona el día con el fichaje incorrecto y pulsa en "Solicitar Corrección". Tu supervisor deberá aprobar el cambio.',
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String pregunta;
  final String respuesta;

  const _FaqItem({required this.pregunta, required this.respuesta});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.primaryTeal,
        collapsedIconColor: AppColors.textSecondary,
        title: Text(
          pregunta,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              respuesta,
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
