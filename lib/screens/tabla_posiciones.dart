import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/partido_model.dart';
import '../models/equipo_model.dart';
import '../models/torneo_model.dart';

class TablaPosicionesPage extends StatelessWidget {
  final Torneo torneo;
  const TablaPosicionesPage({super.key, required this.torneo});

  @override
  Widget build(BuildContext context) {
    final partidosBox = Hive.box('partidos');
    final equiposBox = Hive.box('equipos');

    final partidos = partidosBox.values
        .cast<Partido>()
        .where((p) =>
            p.torneoId == torneo.id &&
            p.marcadorEquipo1 != null &&
            p.marcadorEquipo2 != null)
        .toList();

    final equipos = equiposBox.values
        .cast<Equipo>()
        .where((e) => e.torneoId == torneo.id)
        .toList();

    // Crear mapa con datos acumulados por equipo
    final Map<String, Map<String, int>> tabla = {};

    for (var equipo in equipos) {
      tabla[equipo.id] = {
        'puntos': 0,
        'gf': 0,
        'gc': 0,
        'dg': 0,
      };
    }

    for (var partido in partidos) {
      final e1 = partido.equipo1Id;
      final e2 = partido.equipo2Id;
      final g1 = partido.marcadorEquipo1!;
      final g2 = partido.marcadorEquipo2!;

      tabla[e1]!['gf'] = tabla[e1]!['gf']! + g1;
      tabla[e1]!['gc'] = tabla[e1]!['gc']! + g2;

      tabla[e2]!['gf'] = tabla[e2]!['gf']! + g2;
      tabla[e2]!['gc'] = tabla[e2]!['gc']! + g1;

      if (g1 > g2) {
        tabla[e1]!['puntos'] = tabla[e1]!['puntos']! + 3;
      } else if (g2 > g1) {
        tabla[e2]!['puntos'] = tabla[e2]!['puntos']! + 3;
      } else {
        tabla[e1]!['puntos'] = tabla[e1]!['puntos']! + 1;
        tabla[e2]!['puntos'] = tabla[e2]!['puntos']! + 1;
      }
    }

    for (var datos in tabla.values) {
      datos['dg'] = datos['gf']! - datos['gc']!;
    }

    final listaOrdenada = equipos.toList()
      ..sort((a, b) {
        final datosB = tabla[b.id]!;
        final datosA = tabla[a.id]!;

        if (datosB['puntos'] != datosA['puntos']) {
          return datosB['puntos']!.compareTo(datosA['puntos']!);
        } else {
          return datosB['dg']!.compareTo(datosA['dg']!);
        }
      });

    return Scaffold(
      appBar: AppBar(title: const Text('Tabla de Posiciones')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(flex: 3, child: Text('Equipo', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('PTS', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('GF', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('GC', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('DG', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: listaOrdenada.length,
                itemBuilder: (context, index) {
                  final equipo = listaOrdenada[index];
                  final stats = tabla[equipo.id]!;

                  return Row(
                    children: [
                      Expanded(flex: 3, child: Text(equipo.nombre)),
                      Expanded(child: Text('${stats['puntos']}', textAlign: TextAlign.center)),
                      Expanded(child: Text('${stats['gf']}', textAlign: TextAlign.center)),
                      Expanded(child: Text('${stats['gc']}', textAlign: TextAlign.center)),
                      Expanded(child: Text('${stats['dg']}', textAlign: TextAlign.center)),
                    ],
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
