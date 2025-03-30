import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/equipo_model.dart';
import '../models/torneo_model.dart';

class AgregarEquiposPage extends StatefulWidget {
  final Torneo torneo;
  const AgregarEquiposPage({super.key, required this.torneo});

  @override
  State<AgregarEquiposPage> createState() => _AgregarEquiposPageState();
}

class _AgregarEquiposPageState extends State<AgregarEquiposPage> {
  final TextEditingController _nombreController = TextEditingController();
  final equiposBox = Hive.box('equipos');

  void _guardarEquipo() async {
    if (_nombreController.text.trim().isEmpty) return;

    final nuevoEquipo = Equipo(
      id: const Uuid().v4(),
      nombre: _nombreController.text.trim(),
      torneoId: widget.torneo.id,
    );

    await equiposBox.put(nuevoEquipo.id, nuevoEquipo);
    _nombreController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final equipos = equiposBox.values
        .cast<Equipo>()
        .where((e) => e.torneoId == widget.torneo.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Equipos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Torneo: ${widget.torneo.nombre}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del equipo'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _guardarEquipo,
              child: const Text('Agregar Equipo'),
            ),
            const Divider(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: equipos.length,
                itemBuilder: (context, index) {
                  final equipo = equipos[index];
                  return ListTile(
                    title: Text(equipo.nombre),
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
