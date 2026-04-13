import 'package:flutter/material.dart';
import 'main.dart';

class NominasPage extends StatelessWidget {
  const NominasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'N\u00f3minas y Retribuciones',
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Certificado IRPF 2025',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ya disponible para la Renta',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.download, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Hist\u00f3rico de N\u00f3minas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildNominaCard('Marzo 2026', 'Pagado el 28 Mar'),
          _buildNominaCard('Febrero 2026', 'Pagado el 27 Feb'),
          _buildNominaCard('Enero 2026', 'Pagado el 30 Ene'),
          _buildNominaCard('Paga Extra Navidad 2025', 'Pagado el 15 Dic'),
          _buildNominaCard('Diciembre 2025', 'Pagado el 29 Dic'),
        ],
      ),
    );
  }

  Widget _buildNominaCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryTealLight.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.picture_as_pdf, color: AppColors.primaryTealLight),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Icon(
          Icons.file_download_outlined,
          color: AppColors.textPrimary,
        ),
        onTap: () {},
      ),
    );
  }
}
