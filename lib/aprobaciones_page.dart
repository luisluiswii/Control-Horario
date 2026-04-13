import 'package:flutter/material.dart';
import 'main.dart';

class AprobacionesPage extends StatefulWidget {
  const AprobacionesPage({super.key});

  @override
  State<AprobacionesPage> createState() => _AprobacionesPageState();
}

class _AprobacionesPageState extends State<AprobacionesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Aprobaciones',
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Bandeja actualizada')));
        },
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildApprovalCard(
              'Luc\u00eda R.',
              'Vacaciones Verano',
              'Solicita del 01 Jul al 15 Jul. Tiene d\u00edas disponibles.',
              '14 d\u00edas',
            ),
            _buildApprovalCard(
              'Carlos M.',
              'Cambio de Turno',
              'Solicita cambiar el turno de tarde al turno de ma\u00f1ana.',
              '1 turno',
            ),
            _buildApprovalCard(
              'Ana G.',
              'Justificante M\u00e9dico',
              'Baja m\u00e9dica por enfermedad com\u00fan.',
              '2 d\u00edas',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalCard(
    String person,
    String type,
    String desc,
    String duration,
  ) {
    return Dismissible(
      key: Key(person + type),
      background: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.successGreen.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: Icon(
          Icons.check_circle,
          color: AppColors.successGreen,
          size: 32,
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.cancel, color: Colors.red, size: 32),
      ),
      onDismissed: (direction) {
        String msg = direction == DismissDirection.startToEnd
            ? 'Aprobada'
            : 'Rechazada';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Solicitud $msg')));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.accentSky.withValues(alpha: 0.2),
                    child: Text(
                      person.substring(0, 1),
                      style: TextStyle(color: AppColors.accentSky),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          type,
                          style: TextStyle(
                            color: AppColors.primaryTealLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    duration,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                desc,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Rechazar',
                      style: TextStyle(
                        color: AppColors.dangerRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 48, color: AppColors.border),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Aprobar',
                      style: TextStyle(
                        color: AppColors.successGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
