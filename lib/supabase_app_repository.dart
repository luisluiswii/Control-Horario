import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilUsuario {
  const PerfilUsuario({
    required this.authUserId,
    required this.email,
    required this.nombreCompleto,
    required this.departamento,
    required this.identificacion,
    required this.rol,
    required this.activo,
  });

  final String authUserId;
  final String email;
  final String nombreCompleto;
  final String departamento;
  final String identificacion;
  final String rol;
  final bool activo;

  factory PerfilUsuario.fromMap(Map<String, dynamic> data) {
    return PerfilUsuario(
      authUserId: data['auth_user_id']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      nombreCompleto: data['nombre_completo']?.toString() ?? '',
      departamento: data['departamento']?.toString() ?? '',
      identificacion: data['identificacion']?.toString() ?? '',
      rol: data['rol']?.toString() ?? 'empleado',
      activo: data['activo'] == true,
    );
  }
}

class FichajeRegistroRemote {
  const FichajeRegistroRemote({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.fecha,
  });

  final String id;
  final String usuarioId;
  final String tipo;
  final DateTime fecha;

  factory FichajeRegistroRemote.fromMap(Map<String, dynamic> data) {
    final dynamic rawFecha = data['fecha'] ?? data['created_at'];
    final String fechaIso = rawFecha?.toString() ?? DateTime.now().toUtc().toIso8601String();

    return FichajeRegistroRemote(
      id: data['id']?.toString() ?? '',
      usuarioId:
          data['usuario_id']?.toString() ?? data['auth_user_id']?.toString() ?? '',
      tipo: data['tipo']?.toString() ?? 'entrada',
      fecha: DateTime.parse(fechaIso),
    );
  }
}

class TurnoRegistroRemote {
  const TurnoRegistroRemote({
    required this.id,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.rol,
    required this.ubicacion,
    required this.urgencia,
    required this.urgenciaColor,
    required this.asignadoUsuarioId,
    required this.asignadoUsuarioNombre,
    required this.isFixed,
  });

  final String id;
  final DateTime fecha;
  final String horaInicio;
  final String horaFin;
  final String rol;
  final String ubicacion;
  final String urgencia;
  final String urgenciaColor;
  final String? asignadoUsuarioId;
  final String? asignadoUsuarioNombre;
  final bool isFixed;

  factory TurnoRegistroRemote.fromMap(Map<String, dynamic> data) {
    return TurnoRegistroRemote(
      id: data['id']?.toString() ?? '',
      fecha: DateTime.parse(data['fecha'].toString()),
      horaInicio: data['hora_inicio']?.toString() ?? '08:00',
      horaFin: data['hora_fin']?.toString() ?? '16:00',
      rol: data['rol']?.toString() ?? 'Puesto',
      ubicacion: data['ubicacion']?.toString() ?? 'Sede Principal',
      urgencia: data['urgencia']?.toString() ?? 'Baja',
      urgenciaColor: data['urgencia_color']?.toString() ?? 'success',
      asignadoUsuarioId: data['asignado_usuario_id']?.toString(),
      asignadoUsuarioNombre: data['asignado_usuario_nombre']?.toString(),
      isFixed: data['is_fixed'] == true,
    );
  }

  String get rangoHorario => '$horaInicio - $horaFin';
}

class SupabaseAppRepository {
  static SupabaseClient get _client => Supabase.instance.client;

  static bool _isMissingColumn(Object error, String column) {
    final message = error.toString();
    return message.contains('fichajes.$column does not exist') ||
        (message.contains('42703') && message.contains(column));
  }

  static Future<PerfilUsuario?> loadCurrentProfile() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      return null;
    }

    final data = await _client
        .from('usuario')
        .select()
        .eq('auth_user_id', currentUser.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return PerfilUsuario.fromMap(Map<String, dynamic>.from(data));
  }

  static Future<List<PerfilUsuario>> loadActiveEmployees() async {
    final rows = await _client
        .from('usuario')
        .select()
        .eq('activo', true)
        .order('nombre_completo');

    return rows
        .cast<Map<String, dynamic>>()
        .map(PerfilUsuario.fromMap)
        .toList();
  }

  static Future<List<FichajeRegistroRemote>> loadDayAttendance(
    String authUserId,
    DateTime day,
  ) async {
    final start = DateTime(day.year, day.month, day.day).toUtc();
    final end = start.add(const Duration(days: 1));

    const userColumns = ['usuario_id', 'auth_user_id'];
    const timeColumns = ['fecha', 'created_at'];

    for (final userColumn in userColumns) {
      for (final timeColumn in timeColumns) {
        try {
          final rows = await _client
              .from('fichajes')
              .select()
              .eq(userColumn, authUserId)
              .gte(timeColumn, start.toIso8601String())
              .lt(timeColumn, end.toIso8601String())
              .order(timeColumn);

          return rows
              .cast<Map<String, dynamic>>()
              .map(FichajeRegistroRemote.fromMap)
              .toList();
        } catch (e) {
          final missingUserColumn = _isMissingColumn(e, userColumn);
          final missingTimeColumn = _isMissingColumn(e, timeColumn);
          if (missingUserColumn || missingTimeColumn) {
            continue;
          }
          rethrow;
        }
      }
    }

    throw Exception(
      'No se encontro un esquema compatible para la tabla fichajes. '
      'Se probo con usuario_id/auth_user_id y fecha/created_at.',
    );
  }

  static Future<void> registerAttendance({
    required String authUserId,
    required String tipo,
  }) async {
    const userColumns = ['usuario_id', 'auth_user_id'];
    const timeColumns = ['fecha', 'created_at'];

    for (final userColumn in userColumns) {
      for (final timeColumn in timeColumns) {
        final payload = {
          userColumn: authUserId,
          'tipo': tipo,
          timeColumn: DateTime.now().toUtc().toIso8601String(),
        };

        try {
          await _client.from('fichajes').insert(payload);
          return;
        } catch (e) {
          final missingUserColumn = _isMissingColumn(e, userColumn);
          final missingTimeColumn = _isMissingColumn(e, timeColumn);
          if (missingUserColumn || missingTimeColumn) {
            continue;
          }
          rethrow;
        }
      }
    }

    throw Exception(
      'No se encontro un esquema compatible para insertar en fichajes. '
      'Se probo con usuario_id/auth_user_id y fecha/created_at.',
    );
  }

  static Future<List<TurnoRegistroRemote>> loadShiftsForDay(DateTime day) async {
    final rows = await _client
        .from('turnos')
        .select()
        .eq('fecha', day.toIso8601String().split('T').first)
        .order('hora_inicio');

    return rows
        .cast<Map<String, dynamic>>()
        .map(TurnoRegistroRemote.fromMap)
        .toList();
  }

  static Future<void> createShift({
    required DateTime date,
    required String horaInicio,
    required String horaFin,
    required String rol,
    required String ubicacion,
    required String urgencia,
    required String urgenciaColor,
  }) async {
    await _client.from('turnos').insert({
      'fecha': date.toIso8601String().split('T').first,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'rol': rol,
      'ubicacion': ubicacion,
      'urgencia': urgencia,
      'urgencia_color': urgenciaColor,
      'asignado_usuario_id': null,
      'asignado_usuario_nombre': null,
      'is_fixed': false,
    });
  }

  static Future<void> assignShift({
    required String shiftId,
    required String? userId,
    required String? userName,
  }) async {
    await _client.from('turnos').update({
      'asignado_usuario_id': userId,
      'asignado_usuario_nombre': userName,
    }).eq('id', shiftId);
  }

  static Future<void> deleteShift(String shiftId) async {
    await _client.from('turnos').delete().eq('id', shiftId);
  }
}