import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/equipo_model.dart';
import '../models/torneo_model.dart';
import 'package:uuid/uuid.dart';  // Asegúrate de que esto esté importado

class GestionarTorneoPage extends StatefulWidget {
  final Torneo torneo;

  const GestionarTorneoPage({super.key, required this.torneo});

  @override
  State<GestionarTorneoPage> createState() => _GestionarTorneoPageState();
}

class _GestionarTorneoPageState extends State<GestionarTorneoPage> {
  late Box equiposBox;
  final TextEditingController _nombreEquipoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    equiposBox = Hive.box('equipos');
  }

  void _agregarEquipo() {
    if (_nombreEquipoController.text.isEmpty) return;

    final equipo = Equipo(
      id: const Uuid().v4(),
      nombre: _nombreEquipoController.text,
      torneoId: widget.torneo.id, // Relacionamos el equipo con el torneo
    );

    equiposBox.put(equipo.id, equipo);

    setState(() {}); // Refresca la pantalla
    _nombreEquipoController.clear(); // Limpia el campo de texto
  }

  @override
  Widget build(BuildContext context) {
    final equipos = equiposBox.values
        .cast<Equipo>()
        .where((equipo) => equipo.torneoId == widget.torneo.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Gestionar Torneo: ${widget.torneo.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreEquipoController,
              decoration: const InputDecoration(
                labelText: 'Nombre del equipo',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _agregarEquipo,
              child: const Text('Agregar Equipo'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: equipos.length,
                itemBuilder: (context, index) {
                  final equipo = equipos[index];
                  return ListTile(
                    title: Text(equipo.nombre),
                    subtitle: Text('ID: ${equipo.id}'),
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
