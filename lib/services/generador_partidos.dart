import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/partido_model.dart';
import '../models/equipo_model.dart';
import '../models/torneo_model.dart';

class GeneradorPartidosService {
  static Future<void> generarPartidosParaTorneo(Torneo torneo) async {
    final equiposBox = Hive.box('equipos');
    final partidosBox = Hive.box('partidos');

    final equipos = equiposBox.values
        .cast<Equipo>()
        .where((e) => e.torneoId == torneo.id)
        .toList();

    if (equipos.length < 2) return;

    for (int i = 0; i < equipos.length - 1; i++) {
      for (int j = i + 1; j < equipos.length; j++) {
        final partido = Partido(
          id: const Uuid().v4(),
          torneoId: torneo.id,
          equipo1Id: equipos[i].id,
          equipo2Id: equipos[j].id,
          fecha: torneo.fechaInicio.add(Duration(days: (i + j))),
          lugar: 'Por definir',
          fase: 'Grupos',
        );

        await partidosBox.put(partido.id, partido);
      }
    }
  }

  static Future<void> generarSemifinales(Torneo torneo) async {
    final partidosBox = Hive.box('partidos');

    final partidos = partidosBox.values
        .cast<Partido>()
        .where((p) => p.torneoId == torneo.id && p.fase == 'Grupos')
        .where((p) => p.marcadorEquipo1 != null && p.marcadorEquipo2 != null)
        .toList();

    final Map<String, int> puntos = {};

    for (var partido in partidos) {
      final id1 = partido.equipo1Id;
      final id2 = partido.equipo2Id;
      final g1 = partido.marcadorEquipo1!;
      final g2 = partido.marcadorEquipo2!;

      puntos.putIfAbsent(id1, () => 0);
      puntos.putIfAbsent(id2, () => 0);

      if (g1 > g2) {
        puntos[id1] = puntos[id1]! + 3;
      } else if (g1 < g2) {
        puntos[id2] = puntos[id2]! + 3;
      } else {
        puntos[id1] = puntos[id1]! + 1;
        puntos[id2] = puntos[id2]! + 1;
      }
    }

    final topEquipos = puntos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (topEquipos.length < 4) return;

    final semifinalistas = topEquipos.take(4).map((e) => e.key).toList();

    final List<Map<String, String>> emparejamientos = [
      { 'e1': semifinalistas[0], 'e2': semifinalistas[3] },
      { 'e1': semifinalistas[1], 'e2': semifinalistas[2] },
    ];

    for (var emparejamiento in emparejamientos) {
      final partido = Partido(
        id: const Uuid().v4(),
        torneoId: torneo.id,
        equipo1Id: emparejamiento['e1']!,
        equipo2Id: emparejamiento['e2']!,
        fecha: DateTime.now(),
        lugar: 'Por definir',
        fase: 'Semifinal',
      );

      await partidosBox.put(partido.id, partido);
    }
  }

  static Future<void> generarFinal(Torneo torneo) async {
    final partidosBox = Hive.box('partidos');

    final semifinales = partidosBox.values
        .cast<Partido>()
        .where((p) => p.torneoId == torneo.id && p.fase == 'Semifinal')
        .where((p) => p.marcadorEquipo1 != null && p.marcadorEquipo2 != null)
        .toList();

    if (semifinales.length != 2) return;

    List<String> ganadores = [];

    for (var partido in semifinales) {
      if (partido.marcadorEquipo1! > partido.marcadorEquipo2!) {
        ganadores.add(partido.equipo1Id);
      } else if (partido.marcadorEquipo2! > partido.marcadorEquipo1!) {
        ganadores.add(partido.equipo2Id);
      }
    }

    if (ganadores.length != 2) return;

    final finalPartido = Partido(
      id: const Uuid().v4(),
      torneoId: torneo.id,
      equipo1Id: ganadores[0],
      equipo2Id: ganadores[1],
      fecha: DateTime.now().add(const Duration(days: 1)),
      lugar: 'Estadio principal',
      fase: 'Final',
    );

    await partidosBox.put(finalPartido.id, finalPartido);
  }


static Future<void> generarTercerLugar(Torneo torneo) async {
  final partidosBox = Hive.box('partidos');

  // Obtener las semifinales con resultados
  final semifinales = partidosBox.values
      .cast<Partido>()
      .where((p) => p.torneoId == torneo.id && p.fase == 'Semifinal')
      .where((p) => p.marcadorEquipo1 != null && p.marcadorEquipo2 != null)
      .toList();

  if (semifinales.length != 2) return;

  List<String> perdedores = [];

  for (var partido in semifinales) {
    if (partido.marcadorEquipo1! > partido.marcadorEquipo2!) {
      perdedores.add(partido.equipo2Id);
    } else if (partido.marcadorEquipo2! > partido.marcadorEquipo1!) {
      perdedores.add(partido.equipo1Id);
    }
  }

  if (perdedores.length != 2) return;

  final partidoTercerLugar = Partido(
    id: const Uuid().v4(),
    torneoId: torneo.id,
    equipo1Id: perdedores[0],
    equipo2Id: perdedores[1],
    fecha: DateTime.now().add(const Duration(days: 2)),
    lugar: 'Cancha secundaria',
    fase: 'Tercer Lugar',
  );

  await partidosBox.put(partidoTercerLugar.id, partidoTercerLugar);
}

}
