import 'package:flutter/material.dart';
import 'main.dart';

class DocumentosPage extends StatefulWidget {
  const DocumentosPage({super.key});

  @override
  State<DocumentosPage> createState() => _DocumentosPageState();
}

class _DocumentosPageState extends State<DocumentosPage> {
  final List<Map<String, String>> documentos = [
    {
      'titulo': 'Manual de Empleado',
      'fecha': '10/03/2026',
      'tipo': 'PDF',
      'categoria': 'Empresa',
    },
    {
      'titulo': 'Política de Vacaciones',
      'fecha': '05/01/2026',
      'tipo': 'PDF',
      'categoria': 'Empresa',
    },
    {
      'titulo': 'Contrato Firmado',
      'fecha': '12/10/2025',
      'tipo': 'DOCX',
      'categoria': 'Personales',
    },
    {
      'titulo': 'Justificante Médico',
      'fecha': '15/03/2026',
      'tipo': 'JPG',
      'categoria': 'Personales',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Documentos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: AppColors.white,
          bottom: TabBar(
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.white.withValues(alpha: 0.6),
            indicatorColor: AppColors.accentSky,
            tabs: const [
              Tab(text: 'Mi Repositorio'),
              Tab(text: 'Normativa Empresa'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListaDocumentos('Personales'),
            _buildListaDocumentos('Empresa'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.primaryTealLight,
          icon: const Icon(Icons.upload_file, color: Colors.white),
          label: const Text(
            'Subir Archivo',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildListaDocumentos(String categoria) {
    final filtrados = documentos
        .where((doc) => doc['categoria'] == categoria)
        .toList();
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtrados.length,
      itemBuilder: (context, index) {
        final doc = filtrados[index];
        return Card(
          color: AppColors.surface,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryTealLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.description, color: AppColors.primaryTeal),
            ),
            title: Text(
              doc['titulo']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Subido: ${doc['fecha']} • ${doc['tipo']}',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            trailing: IconButton(
              icon: Icon(Icons.download_rounded, color: AppColors.accentCoral),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
