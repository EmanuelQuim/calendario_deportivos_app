import 'package:flutter/material.dart';
import '../models/torneo_model.dart';
import 'crear_torneo.dart';

class TorneosPage extends StatelessWidget {
  const TorneosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Acá más adelante cargaremos torneos desde Hive
    return Scaffold(
      appBar: AppBar(title: const Text('Torneos')),
      body: const Center(child: Text('Lista de torneos próximamente')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearTorneoPage()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Crear nuevo torneo',
      ),
    );
  }
}
