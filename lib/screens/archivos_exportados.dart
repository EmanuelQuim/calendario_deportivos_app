import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

class ArchivosExportadosPage extends StatefulWidget {
  const ArchivosExportadosPage({super.key});

  @override
  State<ArchivosExportadosPage> createState() => _ArchivosExportadosPageState();
}

class _ArchivosExportadosPageState extends State<ArchivosExportadosPage> {
  List<FileSystemEntity> archivos = [];

  @override
  void initState() {
    super.initState();
    cargarArchivos();
  }

  Future<void> cargarArchivos() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().where((file) {
      return file.path.endsWith('.csv') || file.path.endsWith('.pdf');
    }).toList();

    setState(() {
      archivos = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archivos Exportados')),
      body: archivos.isEmpty
          ? const Center(child: Text('No hay archivos exportados aún'))
          : ListView.builder(
              itemCount: archivos.length,
              itemBuilder: (context, index) {
                final archivo = archivos[index];
                final nombre = archivo.path.split('/').last;

                return ListTile(
                  leading: Icon(
                    archivo.path.endsWith('.pdf') ? Icons.picture_as_pdf : Icons.description,
                  ),
                  title: Text(nombre),
                  subtitle: Text(archivo.path),
                  trailing: IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      Share.shareXFiles([XFile(archivo.path)], text: 'Archivo generado desde la app');
                    },
                  ),
                  onTap: () async {
                    await OpenFile.open(archivo.path);
                  },
                );
              },
            ),
    );
  }
}
