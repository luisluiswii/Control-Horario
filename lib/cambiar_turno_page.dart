import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart';

class CambiarTurnoPage extends StatefulWidget {
  const CambiarTurnoPage({super.key});

  @override
  State<CambiarTurnoPage> createState() => _CambiarTurnoPageState();
}

class _CambiarTurnoPageState extends State<CambiarTurnoPage> {
  // --- FORMULARIO NUEVA SOLICITUD ---
  DateTime? fechaSeleccionada;
  String? companeroSeleccionado;
  final motivoController = TextEditingController();
  bool enviando = false;

  // --- COMPAÑEROS ---
  List<Map<String, dynamic>> companeros = [];
  bool cargandoCompaneros = true;

  // --- SOLICITUDES ---
  List<Map<String, dynamic>> solicitudesEnviadas = [];
  List<Map<String, dynamic>> solicitudesRecibidas = [];
  bool cargandoSolicitudes = true;

  @override
  void initState() {
    super.initState();
    cargarCompaneros();
    cargarSolicitudes();
  }

  @override
  void dispose() {
    motivoController.dispose();
    super.dispose();
  }

  SupabaseClient get _client => Supabase.instance.client;

  // =========================
  //   CARGAR COMPAÑEROS
  // =========================
  Future<void> cargarCompaneros() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return;

      final data = await _client
          .from('usuario')
          .select('auth_user_id, nombre_completo')
          .eq('activo', true)
          .neq('auth_user_id', user.id)
          .order('nombre_completo');

      setState(() {
        companeros = List<Map<String, dynamic>>.from(data);
        cargandoCompaneros = false;
      });
    } catch (e) {
      debugPrint('Error cargando compañeros: $e');
      setState(() => cargandoCompaneros = false);
    }
  }

  // =========================
  //   CARGAR SOLICITUDES
  // =========================
  Future<void> cargarSolicitudes() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return;

      setState(() => cargandoSolicitudes = true);

      final data = await _client
          .from('solicitudes_cambio_turno')
          .select(
        'id, solicitante_id, companero_id, fecha_turno, motivo, estado, fecha_solicitud, fecha_respuesta',
      )
          .or('solicitante_id.eq.${user.id},companero_id.eq.${user.id}')
          .order('fecha_solicitud', ascending: false);

      final solicitudes =
      List<Map<String, dynamic>>.from(data as List<dynamic>);

      // Obtener nombres
      final ids = <String>{};
      for (final s in solicitudes) {
        ids.add(s['solicitante_id']);
        ids.add(s['companero_id']);
      }

      Map<String, String> nombresPorId = {};
      if (ids.isNotEmpty) {
        final usuariosData = await _client
            .from('usuario')
            .select('auth_user_id, nombre_completo')
            .inFilter('auth_user_id', ids.toList());

        for (final u in usuariosData) {
          nombresPorId[u['auth_user_id']] = u['nombre_completo'];
        }
      }

      final enviadas = <Map<String, dynamic>>[];
      final recibidas = <Map<String, dynamic>>[];

      for (final s in solicitudes) {
        final enriched = {
          ...s,
          'solicitante_nombre':
          nombresPorId[s['solicitante_id']] ?? 'Desconocido',
          'companero_nombre':
          nombresPorId[s['companero_id']] ?? 'Desconocido',
          'es_solicitante': s['solicitante_id'] == user.id,
          'es_companero': s['companero_id'] == user.id,
        };

        if (s['solicitante_id'] == user.id) enviadas.add(enriched);
        if (s['companero_id'] == user.id) recibidas.add(enriched);
      }

      setState(() {
        solicitudesEnviadas = enviadas;
        solicitudesRecibidas = recibidas;
        cargandoSolicitudes = false;
      });
    } catch (e) {
      debugPrint('Error cargando solicitudes: $e');
      setState(() => cargandoSolicitudes = false);
    }
  }

  // =========================
  //   ENVIAR NUEVA SOLICITUD
  // =========================
  Future<void> _enviarSolicitud() async {
    if (fechaSeleccionada == null) {
      _showSnack('Selecciona un día para el turno.');
      return;
    }
    if (companeroSeleccionado == null) {
      _showSnack('Selecciona un compañero.');
      return;
    }

    final user = _client.auth.currentUser;
    if (user == null) {
      _showSnack('Sesión no válida.');
      return;
    }

    try {
      setState(() => enviando = true);

      final motivo = motivoController.text.trim();
      final fechaTurnoStr =
          '${fechaSeleccionada!.year}-${fechaSeleccionada!.month.toString().padLeft(2, '0')}-${fechaSeleccionada!.day.toString().padLeft(2, '0')}';

      await _client.from('solicitudes_cambio_turno').insert({
        'solicitante_id': user.id,
        'companero_id': companeroSeleccionado,
        'fecha_turno': fechaTurnoStr,
        'motivo': motivo.isEmpty ? null : motivo,
      });

      setState(() {
        fechaSeleccionada = null;
        companeroSeleccionado = null;
        motivoController.clear();
      });

      _showSnack('Solicitud enviada correctamente.',
          color: AppColors.successGreen);

      await cargarSolicitudes();
    } catch (e) {
      debugPrint('Error enviando solicitud: $e');
      _showSnack('No se pudo enviar la solicitud.');
    } finally {
      if (mounted) setState(() => enviando = false);
    }
  }

  // =========================
  //   ACTUALIZAR ESTADO
  // =========================
  Future<void> _actualizarEstado(
      Map<String, dynamic> solicitud, String nuevoEstado) async {
    try {
      await _client
          .from('solicitudes_cambio_turno')
          .update({
        'estado': nuevoEstado,
        'fecha_respuesta': DateTime.now().toIso8601String(),
      })
          .eq('id', solicitud['id']);

      await cargarSolicitudes();

      String msg;
      switch (nuevoEstado) {
        case 'aceptada':
          msg = 'Has aceptado la solicitud.';
          break;
        case 'rechazada':
          msg = 'Has rechazado la solicitud.';
          break;
        case 'cancelada':
          msg = 'Has cancelado tu solicitud.';
          break;
        default:
          msg = 'Estado actualizado.';
      }

      _showSnack(msg, color: AppColors.successGreen);
    } catch (e) {
      debugPrint('Error actualizando estado: $e');
      _showSnack('No se pudo actualizar la solicitud.');
    }
  }

  void _showSnack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color ?? Colors.red,
      ),
    );
  }

  // =========================
  //   BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Cambiar Turno',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: AppColors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: cargarSolicitudes,
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.accentSky,
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.white.withValues(alpha: 0.6),
            tabs: const [
              Tab(text: 'Nueva Solicitud'),
              Tab(text: 'Mis Solicitudes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFormulario(),
            _buildMisSolicitudes(),
          ],
        ),
      ),
    );
  }

  // =========================
  //   FORMULARIO
  // =========================
  Widget _buildFormulario() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalles del Cambio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _seleccionarFecha,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Text(
                    fechaSeleccionada == null
                        ? 'Seleccionar día'
                        : '${fechaSeleccionada!.day.toString().padLeft(2, '0')}/'
                        '${fechaSeleccionada!.month.toString().padLeft(2, '0')}/'
                        '${fechaSeleccionada!.year}',
                    style: TextStyle(
                      color: fechaSeleccionada == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          cargandoCompaneros
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<String>(
            value: companeroSeleccionado,
            decoration: InputDecoration(
              labelText: 'Compañero propuesto',
              prefixIcon:
              Icon(Icons.person, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: companeros.map((comp) {
              return DropdownMenuItem<String>(
                value: comp['auth_user_id'] as String,
                child: Text(comp['nombre_completo'] as String),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => companeroSeleccionado = value);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: motivoController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Motivo del cambio (Opcional)',
              alignLabelWithHint: true,
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTealLight,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: enviando ? null : _enviarSolicitud,
              child: enviando
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text(
                'Enviar Solicitud',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();

    final fecha = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 365)),
      helpText: 'Selecciona el día del turno',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (fecha != null) {
      setState(() => fechaSeleccionada = fecha);
    }
  }

  // =========================
  //   MIS SOLICITUDES
  // =========================
  Widget _buildMisSolicitudes() {
    if (cargandoSolicitudes) {
      return const Center(child: CircularProgressIndicator());
    }

    if (solicitudesEnviadas.isEmpty && solicitudesRecibidas.isEmpty) {
      return const Center(
        child: Text(
          'No tienes solicitudes de cambio de turno.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: cargarSolicitudes,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (solicitudesEnviadas.isNotEmpty) ...[
            Text(
              'Enviadas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...solicitudesEnviadas.map(_buildSolicitudCard),
            const SizedBox(height: 16),
          ],
          if (solicitudesRecibidas.isNotEmpty) ...[
            Text(
              'Recibidas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...solicitudesRecibidas.map(_buildSolicitudCard),
          ],
        ],
      ),
    );
  }

  Widget _buildSolicitudCard(Map<String, dynamic> solicitud) {
    final esSolicitante = solicitud['es_solicitante'] as bool? ?? false;
    final esCompanero = solicitud['es_companero'] as bool? ?? false;
    final estado = (solicitud['estado'] as String).toLowerCase();
    final fechaTurno = DateTime.parse(solicitud['fecha_turno'] as String);
    final fechaSolicitud =
    DateTime.parse(solicitud['fecha_solicitud'] as String);

    Color estadoColor;
    String estadoTexto;

    switch (estado) {
      case 'pendiente':
        estadoColor = Colors.orange;
        estadoTexto = 'Pendiente';
        break;
      case 'aceptada':
        estadoColor = Colors.green;
        estadoTexto = 'Aceptada';
        break;
      case 'rechazada':
        estadoColor = Colors.redAccent;
        estadoTexto = 'Rechazada';
        break;
      case 'cancelada':
        estadoColor = Colors.grey;
        estadoTexto = 'Cancelada';
        break;
      default:
        estadoColor = Colors.blueGrey;
        estadoTexto = estado;
    }

    final titulo = esSolicitante
        ? 'Tú → ${solicitud['companero_nombre']}'
        : '${solicitud['solicitante_nombre']} → Tú';

    final motivo = solicitud['motivo'] as String?;
    final puedeCancelar = esSolicitante && estado == 'pendiente';
    final puedeAceptarRechazar = esCompanero && estado == 'pendiente';

    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: estadoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    estadoTexto,
                    style: TextStyle(
                      color: estadoColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Día del turno: '
                  '${fechaTurno.day.toString().padLeft(2, '0')}/'
                  '${fechaTurno.month.toString().padLeft(2, '0')}/'
                  '${fechaTurno.year}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Solicitada el: '
                  '${fechaSolicitud.day.toString().padLeft(2, '0')}/'
                  '${fechaSolicitud.month.toString().padLeft(2, '0')}/'
                  '${fechaSolicitud.year} '
                  '${fechaSolicitud.hour.toString().padLeft(2, '0')}:'
                  '${fechaSolicitud.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            if (motivo != null && motivo.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Motivo:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                motivo,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 8),
            if (puedeCancelar || puedeAceptarRechazar)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (puedeCancelar)
                    TextButton.icon(
                      onPressed: () => _confirmarAccion(
                        solicitud,
                        'cancelada',
                        '¿Seguro que quieres cancelar esta solicitud?',
                      ),
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('Cancelar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                    ),
                  if (puedeAceptarRechazar) ...[
                    TextButton.icon(
                      onPressed: () => _confirmarAccion(
                        solicitud,
                        'rechazada',
                        '¿Seguro que quieres rechazar esta solicitud?',
                      ),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Rechazar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    TextButton.icon(
                      onPressed: () => _confirmarAccion(
                        solicitud,
                        'aceptada',
                        '¿Seguro que quieres aceptar esta solicitud?',
                      ),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Aceptar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarAccion(
      Map<String, dynamic> solicitud,
      String nuevoEstado,
      String mensaje,
      ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar acción'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await _actualizarEstado(solicitud, nuevoEstado);
    }
  }
}