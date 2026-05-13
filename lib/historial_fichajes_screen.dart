import 'dart:io';
import 'dart:typed_data';
import 'documentos_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HistorialFichajesScreen extends StatefulWidget {
  const HistorialFichajesScreen({super.key});

  @override
  State<HistorialFichajesScreen> createState() => _HistorialFichajesScreenState();
}

class _HistorialFichajesScreenState extends State<HistorialFichajesScreen> {
  final supabase = Supabase.instance.client;

  List<dynamic> fichajes = [];
  List<String> ocultos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadOcultos();
  }

  // ---------------------------------------------------------
  // CARGAR / GUARDAR OCULTOS
  // ---------------------------------------------------------
  Future<void> _loadOcultos() async {
    final prefs = await SharedPreferences.getInstance();
    ocultos = prefs.getStringList("fichajes_ocultos") ?? [];
    _loadFichajes();
  }

  Future<void> _saveOcultos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("fichajes_ocultos", ocultos);
  }

  // ---------------------------------------------------------
  // CARGAR FICHAJES
  // ---------------------------------------------------------
  Future<void> _loadFichajes() async {
    final user = supabase.auth.currentUser;

    final response = await supabase
        .from('fichajes')
        .select()
        .eq('auth_user_id', user!.id)
        .order('fecha_hora', ascending: false);

    setState(() {
      fichajes = response;
      loading = false;
    });
  }

  // ---------------------------------------------------------
  // ELIMINAR UNO
  // ---------------------------------------------------------
  Future<void> _eliminarUno(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: const Text("¿Seguro que quieres eliminar este registro del historial?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Eliminar")),
        ],
      ),
    );

    if (confirmar == true) {
      ocultos.add(id);
      await _saveOcultos();
      setState(() {});
    }
  }

  // ---------------------------------------------------------
  // ELIMINAR TODO
  // ---------------------------------------------------------
  Future<void> _eliminarTodo() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar todo"),
        content: const Text("¿Seguro que quieres eliminar TODO el historial?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Eliminar todo")),
        ],
      ),
    );

    if (confirmar == true) {
      ocultos = fichajes.map<String>((e) => e['id'] as String).toList();
      await _saveOcultos();
      setState(() {});
    }
  }

  // ---------------------------------------------------------
  // GUARDAR PDF EN LOCAL
  // ---------------------------------------------------------
  Future<File> guardarPDFLocal(Uint8List bytes, String nombre) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$nombre.pdf");
    await file.writeAsBytes(bytes);
    return file;
  }

  // ---------------------------------------------------------
  // GENERAR PDF
  // ---------------------------------------------------------
  Future<void> _exportarPDF(List<dynamic> datos, String titulo) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(titulo, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            ...datos.map((item) {
              final fecha = DateTime.parse(item['fecha_hora']);
              final tipo = item['tipo'];

              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(
                  "${tipo.toUpperCase()} - "
                      "${fecha.day}/${fecha.month}/${fecha.year} "
                      "${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}",
                  style: const pw.TextStyle(fontSize: 14),
                ),
              );
            }),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();
    final nombre = "historial_${DateTime.now().millisecondsSinceEpoch}";

    await guardarPDFLocal(bytes, nombre);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: const Text("PDF guardado en Documentos"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pushNamed(context, "/documentos");
                },
                child: const Text("Ver"),
              ),
            ],
          );
        },
      );
    }
  }

  // ---------------------------------------------------------
  // CALENDARIO
  // ---------------------------------------------------------
  Future<void> _mostrarCalendario(List<dynamic> visibles) async {
    PickerDateRange? rangoSeleccionado;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Selecciona el rango de días que quieres descargar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: 420,
          width: 350,
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            showActionButtons: true,
            backgroundColor: Colors.white,
            selectionColor: const Color(0xFF0C4A6E),
            startRangeSelectionColor: const Color(0xFF0C4A6E),
            endRangeSelectionColor: const Color(0xFF0C4A6E),
            rangeSelectionColor: const Color(0xFF0C4A6E).withOpacity(0.15),
            todayHighlightColor: const Color(0xFF0C4A6E),
            headerStyle: const DateRangePickerHeaderStyle(
              backgroundColor: Color(0xFF0C4A6E),
              textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            monthCellStyle: const DateRangePickerMonthCellStyle(
              todayTextStyle: TextStyle(color: Color(0xFF0C4A6E), fontWeight: FontWeight.bold),
            ),
            onSelectionChanged: (args) {
              if (args.value is PickerDateRange) {
                rangoSeleccionado = args.value;
              }
            },
            onSubmit: (value) => Navigator.pop(context),
            onCancel: () {
              rangoSeleccionado = null;
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );

    if (rangoSeleccionado == null) return;

    final start = rangoSeleccionado!.startDate!;
    final end = rangoSeleccionado!.endDate ?? start;

    final filtrados = visibles.where((f) {
      final fecha = DateTime.parse(f['fecha_hora']);
      return fecha.isAfter(start.subtract(const Duration(days: 1))) &&
          fecha.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    if (filtrados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay fichajes en ese rango")),
      );
      return;
    }

    _exportarPDF(
      filtrados,
      "Historial (${start.day}/${start.month} - ${end.day}/${end.month})",
    );
  }

  // ---------------------------------------------------------
  // MENÚ PDF
  // ---------------------------------------------------------
  void _mostrarOpcionesPDF(List<dynamic> visibles) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text("Exportar rango personalizado"),
              onTap: () {
                Navigator.pop(context);
                _mostrarCalendario(visibles);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("Exportar todo el historial"),
              onTap: () {
                Navigator.pop(context);
                _exportarPDF(visibles, "Historial completo");
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final visibles = fichajes.where((f) => !ocultos.contains(f['id'])).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Fichajes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: visibles.isEmpty ? null : () => _mostrarOpcionesPDF(visibles),
          ),
          IconButton(
            tooltip: "Eliminar todo",
            onPressed: visibles.isEmpty ? null : _eliminarTodo,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_forever, color: Colors.red),
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : visibles.isEmpty
          ? const Center(
        child: Text(
          "No hay registros visibles.\n(Has ocultado todo el historial)",
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        itemCount: visibles.length,
        itemBuilder: (context, index) {
          final item = visibles[index];
          final tipo = item['tipo'];
          final fecha = DateTime.parse(item['fecha_hora']);

          return ListTile(
            leading: Icon(
              tipo == "entrada" ? Icons.login : Icons.logout,
              color: tipo == "entrada" ? Colors.green : Colors.red,
            ),
            title: Text(tipo == "entrada" ? "Entrada" : "Salida"),
            subtitle: Text(
              "${fecha.day}/${fecha.month}/${fecha.year} - "
                  "${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}",
            ),
            trailing: InkWell(
              onTap: () => _eliminarUno(item['id']),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.red, size: 22),
              ),
            ),
          );
        },
      ),
    );
  }
}
