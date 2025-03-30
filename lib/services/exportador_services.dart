import 'dart:io';
import 'package:csv/csv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/partido_model.dart';
import '../models/equipo_model.dart';
import '../models/torneo_model.dart';

class ExportadorService {
  /// Exportar partidos a CSV
  static Future<File?> exportarPartidosCSV(Torneo torneo) async {
    final partidosBox = Hive.box('partidos');
    final equiposBox = Hive.box('equipos');

    final partidos = partidosBox.values
        .cast<Partido>()
        .where((p) => p.torneoId == torneo.id)
        .toList();

    final List<List<String>> rows = [];

    // Encabezados
    rows.add([
      'Fecha',
      'Equipo 1',
      'Equipo 2',
      'Marcador',
      'Lugar',
      'Fase',
    ]);

    for (var partido in partidos) {
      final equipo1 = equiposBox.get(partido.equipo1Id) as Equipo?;
      final equipo2 = equiposBox.get(partido.equipo2Id) as Equipo?;

      rows.add([
        '${partido.fecha.day}/${partido.fecha.month}/${partido.fecha.year}',
        equipo1?.nombre ?? 'Equipo 1',
        equipo2?.nombre ?? 'Equipo 2',
        (partido.marcadorEquipo1 != null && partido.marcadorEquipo2 != null)
            ? '${partido.marcadorEquipo1} - ${partido.marcadorEquipo2}'
            : 'Sin resultado',
        partido.lugar,
        partido.fase,
      ]);
    }

    final csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/calendario_${torneo.nombre}.csv');

    await file.writeAsString(csvData);
    return file;
  }

  /// Exportar partidos a PDF
  static Future<File?> exportarPartidosPDF(Torneo torneo) async {
    final partidosBox = Hive.box('partidos');
    final equiposBox = Hive.box('equipos');

    final partidos = partidosBox.values
        .cast<Partido>()
        .where((p) => p.torneoId == torneo.id)
        .toList();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text('Calendario del Torneo: ${torneo.nombre}',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Fecha', 'Equipo 1', 'Equipo 2', 'Marcador', 'Lugar', 'Fase'],
              data: partidos.map((p) {
                final e1 = equiposBox.get(p.equipo1Id) as Equipo?;
                final e2 = equiposBox.get(p.equipo2Id) as Equipo?;
                return [
                  '${p.fecha.day}/${p.fecha.month}/${p.fecha.year}',
                  e1?.nombre ?? 'Equipo 1',
                  e2?.nombre ?? 'Equipo 2',
                  (p.marcadorEquipo1 != null && p.marcadorEquipo2 != null)
                      ? '${p.marcadorEquipo1} - ${p.marcadorEquipo2}'
                      : 'Sin resultado',
                  p.lugar,
                  p.fase,
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/calendario_${torneo.nombre}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Compartir cualquier archivo (CSV o PDF)
  static Future<void> compartirArchivo(File archivo) async {
    if (await archivo.exists()) {
      await Share.shareXFiles(
        [XFile(archivo.path)],
        text: 'Compartido desde la app de calendario deportivo',
      );
    }
  }
}
