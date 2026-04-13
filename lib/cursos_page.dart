import 'package:flutter/material.dart';
import 'main.dart';

class CursosPage extends StatelessWidget {
  final List<Map<String, dynamic>> cursos = [
    {
      'titulo': 'Seguridad en la Oficina',
      'progreso': 1.0,
      'horas': 2,
      'cat': 'Obligatorio',
    },
    {
      'titulo': 'Comunicación Efectiva',
      'progreso': 0.6,
      'horas': 4,
      'cat': 'Habilidades',
    },
    {
      'titulo': 'Liderazgo de Equipos',
      'progreso': 0.0,
      'horas': 6,
      'cat': 'Desarrollo',
    },
  ];

  CursosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Mis Cursos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: AppColors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: AppColors.accentSky,
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.white.withValues(alpha: 0.6),
            tabs: const [
              Tab(text: 'En Progreso'),
              Tab(text: 'Completados'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildListaCursos(false), _buildListaCursos(true)],
        ),
      ),
    );
  }

  Widget _buildListaCursos(bool completados) {
    final filtrados = cursos
        .where((c) => completados ? c['progreso'] == 1.0 : c['progreso'] < 1.0)
        .toList();

    if (filtrados.isEmpty) {
      return Center(
        child: Text(
          completados
              ? 'No hay cursos completados aún'
              : 'No tienes cursos pendientes',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtrados.length,
      itemBuilder: (context, index) {
        final curso = filtrados[index];
        bool isCompletado = curso['progreso'] == 1.0;

        return Card(
          color: AppColors.surface,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.play_lesson,
                        color: AppColors.primaryTeal,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentCoral.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              curso['cat'],
                              style: TextStyle(
                                color: AppColors.accentCoral,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            curso['titulo'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${curso['horas']} horas certificadas',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: curso['progreso'],
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompletado
                              ? AppColors.successGreen
                              : AppColors.primaryTealLight,
                        ),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(curso['progreso'] * 100).toInt()}%',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              InkWell(
                onTap: () {},
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  child: Text(
                    isCompletado
                        ? 'Descargar Certificado'
                        : (curso['progreso'] == 0.0
                              ? 'Comenzar Curso'
                              : 'Continuar Curso'),
                    style: TextStyle(
                      color: isCompletado
                          ? AppColors.successGreen
                          : AppColors.primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
