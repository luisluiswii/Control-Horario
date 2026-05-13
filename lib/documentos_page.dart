import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'main.dart';

class DocumentosPage extends StatefulWidget {
  const DocumentosPage({super.key});

  @override
  State<DocumentosPage> createState() => DocumentosPageState();
}

class DocumentosPageState extends State<DocumentosPage> {

  List<Map<String, String>> documentos = [];
  final TextEditingController _busquedaController = TextEditingController();
  String _query = "";

  @override
  void initState() {
    super.initState();
    _cargarPDFsLocales();
  }

  // ---------------------------------------------------------
  // CARGAR PDFs LOCALES
  // ---------------------------------------------------------
  Future<void> _cargarPDFsLocales() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = Directory(dir.path).listSync();

    final pdfs = files.where((f) => f.path.endsWith('.pdf')).toList();

    documentos.clear();

    for (var file in pdfs) {
      final name = file.path.split('/').last.replaceAll('.pdf', '');
      final fecha = File(file.path).lastModifiedSync();

      documentos.add({
        'titulo': name,
        'fecha': _formatearFecha(fecha),
        'tipo': 'PDF',
        'categoria': 'Personales',
        'path': file.path,
        'timestamp': fecha.millisecondsSinceEpoch.toString(),
      });
    }

    documentos.sort((a, b) {
      final t1 = int.tryParse(a['timestamp'] ?? '0') ?? 0;
      final t2 = int.tryParse(b['timestamp'] ?? '0') ?? 0;
      return t2.compareTo(t1);
    });

    setState(() {});
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day.toString().padLeft(2, '0')}/"
        "${fecha.month.toString().padLeft(2, '0')}/"
        "${fecha.year}";
  }

  // ---------------------------------------------------------
  // ABRIR DOCUMENTO
  // ---------------------------------------------------------
  void _abrirDocumento(String? path) {
    if (path == null) return;
    OpenFilex.open(path);
  }

  // ---------------------------------------------------------
  // CONFIRMAR BORRADO INDIVIDUAL
  // ---------------------------------------------------------
  Future<bool> _confirmarBorrado() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar documento"),
        content: const Text("¿Seguro que quieres eliminar este documento?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    return confirmar ?? false;
  }

  // ---------------------------------------------------------
  // BORRAR DOCUMENTO INDIVIDUAL
  // ---------------------------------------------------------
  Future<void> _borrarDocumento(Map<String, String> doc) async {
    final ok = await _confirmarBorrado();
    if (!ok) return;

    if (doc['path'] != null) {
      final file = File(doc['path']!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    documentos.remove(doc);
    setState(() {});
  }

  // ---------------------------------------------------------
  // RENOMBRAR DOCUMENTO
  // ---------------------------------------------------------
  Future<void> _renombrarDocumento(Map<String, String> doc) async {
    final controller = TextEditingController(text: doc['titulo']);

    final nuevoNombre = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Renombrar documento"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Nuevo nombre"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Guardar"),
            onPressed: () => Navigator.pop(context, controller.text.trim()),
          ),
        ],
      ),
    );

    if (nuevoNombre == null || nuevoNombre.isEmpty) return;

    if (doc['path'] != null) {
      final oldFile = File(doc['path']!);
      final dir = oldFile.parent.path;
      final newPath = "$dir/$nuevoNombre.pdf";

      await oldFile.rename(newPath);
      doc['path'] = newPath;
    }

    doc['titulo'] = nuevoNombre;
    setState(() {});
  }

  // ---------------------------------------------------------
  // CONFIRMAR BORRADO MASIVO
  // ---------------------------------------------------------
  Future<void> _eliminarTodosLosDocumentos() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar todos los documentos"),
        content: const Text("¿Seguro que quieres eliminar TODOS los PDFs guardados?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar todo", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _borrarTodosLosPDF();
    }
  }

  // ---------------------------------------------------------
  // BORRAR TODOS LOS PDFs
  // ---------------------------------------------------------
  Future<void> _borrarTodosLosPDF() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = Directory(dir.path).listSync();

    for (var file in files) {
      if (file is File && file.path.endsWith(".pdf")) {
        await file.delete();
      }
    }

    documentos.clear();

    if (mounted) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Todos los documentos han sido eliminados"),
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }

    setState(() {});
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------
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
          actions: [
            IconButton(
              tooltip: "Eliminar todos los documentos",
              onPressed: documentos.isEmpty ? null : _eliminarTodosLosDocumentos,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _busquedaController,
                onChanged: (value) {
                  setState(() => _query = value.trim().toLowerCase());
                },
                decoration: InputDecoration(
                  hintText: "Buscar documento...",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildListaDocumentos('Personales'),
            _buildListaDocumentos('Empresa'),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // LISTA DE DOCUMENTOS + BÚSQUEDA
  // ---------------------------------------------------------
  Widget _buildListaDocumentos(String categoria) {
    final filtrados = documentos.where((doc) {
      final coincideCategoria = doc['categoria'] == categoria;
      final coincideBusqueda = _query.isEmpty ||
          doc['titulo']!.toLowerCase().contains(_query);
      return coincideCategoria && coincideBusqueda;
    }).toList();

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
            onTap: () => _abrirDocumento(doc['path']),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryTealLight.withOpacity(0.1),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () => _renombrarDocumento(doc),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _borrarDocumento(doc),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
