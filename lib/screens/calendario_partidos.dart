import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/partido_model.dart';
import '../models/equipo_model.dart';
import '../models/torneo_model.dart';

class CalendarioPartidosPage extends StatelessWidget {
  final Torneo torneo;
  const CalendarioPartidosPage({super.key, required this.torneo});

  @override
  Widget build(BuildContext context) {
    final partidosBox = Hive.box('partidos');
    final equiposBox = Hive.box('equipos');

    final partidos = partidosBox.values
        .cast<Partido>()
        .where((p) => p.torneoId == torneo.id)
        .toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    return Scaffold(
      appBar: AppBar(title: Text('Calendario: ${torneo.nombre}')),
      body: ListView.builder(
        itemCount: partidos.length,
        itemBuilder: (context, index) {
          final partido = partidos[index];
          final equipo1 =
              equiposBox.get(partido.equipo1Id) as Equipo?;
          final equipo2 =
              equiposBox.get(partido.equipo2Id) as Equipo?;

          return ListTile(
            title: Text(
              '${equipo1?.nombre ?? 'Equipo 1'} vs ${equipo2?.nombre ?? 'Equipo 2'}',
            ),
            subtitle: Text(
              '${partido.fecha.day}/${partido.fecha.month}/${partido.fecha.year} - ${partido.lugar}',
            ),
            trailing: Text(
              partido.marcadorEquipo1 != null && partido.marcadorEquipo2 != null
                  ? '${partido.marcadorEquipo1} - ${partido.marcadorEquipo2}'
                  : 'Sin resultado',
            ),
            onTap: () {
              // Aquí podrías abrir una pantalla para registrar resultado
            },
          );
        },
      ),
    );
  }
}
