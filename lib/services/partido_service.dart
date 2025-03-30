import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/partido_model.dart';
import '../models/equipo_model.dart';
import '../models/torneo_model.dart';

class PartidoService {
  static Future<void> generarPartidos(Torneo torneo) async {
    final equiposBox = Hive.box('equipos');
    final partidosBox = Hive.box('partidos');

    final equipos = equiposBox.values
        .cast<Equipo>()
        .where((e) => e.torneoId == torneo.id)
        .toList();

    if (equipos.length < 2) return;  // Si hay menos de 2 equipos, no tiene sentido generar partidos.

    // Generar los partidos
    for (int i = 0; i < equipos.length - 1; i++) {
      for (int j = i + 1; j < equipos.length; j++) {
        final partido = Partido(
          id: const Uuid().v4(),
          torneoId: torneo.id,
          equipo1Id: equipos[i].id,
          equipo2Id: equipos[j].id,
          fecha: torneo.fechaInicio.add(Duration(days: (i + j))), // Distribuir fechas
          lugar: 'Por definir',
          fase: 'Grupos',
        );

        await partidosBox.put(partido.id, partido);
      }
    }
  }
}
