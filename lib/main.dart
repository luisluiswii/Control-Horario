import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Horario',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ControlHorarioPage(),
    );
  }
}

enum TipoRegistro { entrada, salida }

class RegistroHorario {
  const RegistroHorario({required this.tipo, required this.fecha});

  final TipoRegistro tipo;
  final DateTime fecha;
}

class ControlHorarioPage extends StatefulWidget {
  const ControlHorarioPage({super.key});

  @override
  State<ControlHorarioPage> createState() => _ControlHorarioPageState();
}

class _ControlHorarioPageState extends State<ControlHorarioPage> {
  final List<RegistroHorario> _registros = [];

  void _registrar(TipoRegistro tipo) {
    setState(() {
      _registros.insert(0, RegistroHorario(tipo: tipo, fecha: DateTime.now()));
    });
  }

  String _hora(DateTime fecha) {
    final horas = fecha.hour.toString().padLeft(2, '0');
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final segundos = fecha.second.toString().padLeft(2, '0');
    return '$horas:$minutos:$segundos';
  }

  String _fecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Control Horario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hoy: ${_fecha(ahora)}'),
                    const SizedBox(height: 4),
                    Text(
                      'Hora actual: ${_hora(ahora)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _registrar(TipoRegistro.entrada),
                    icon: const Icon(Icons.login),
                    label: const Text('Registrar entrada'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _registrar(TipoRegistro.salida),
                    icon: const Icon(Icons.logout),
                    label: const Text('Registrar salida'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Registros de hoy',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _registros.isEmpty
                  ? const Center(child: Text('Sin registros todavía'))
                  : ListView.separated(
                      itemCount: _registros.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final registro = _registros[index];
                        final esEntrada = registro.tipo == TipoRegistro.entrada;
                        return ListTile(
                          leading: Icon(
                            esEntrada ? Icons.login : Icons.logout,
                            color: esEntrada ? Colors.green : Colors.orange,
                          ),
                          title: Text(esEntrada ? 'Entrada' : 'Salida'),
                          subtitle: Text(_fecha(registro.fecha)),
                          trailing: Text(_hora(registro.fecha)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
