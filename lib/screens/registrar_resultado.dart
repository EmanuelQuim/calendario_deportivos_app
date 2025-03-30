import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/partido_model.dart';
import '../models/equipo_model.dart';

class RegistrarResultadoPage extends StatefulWidget {
  final Partido partido;
  const RegistrarResultadoPage({super.key, required this.partido});

  @override
  State<RegistrarResultadoPage> createState() => _RegistrarResultadoPageState();
}

class _RegistrarResultadoPageState extends State<RegistrarResultadoPage> {
  final TextEditingController _goles1Controller = TextEditingController();
  final TextEditingController _goles2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar resultados existentes si los hay
    if (widget.partido.marcadorEquipo1 != null) {
      _goles1Controller.text = widget.partido.marcadorEquipo1.toString();
    }
    if (widget.partido.marcadorEquipo2 != null) {
      _goles2Controller.text = widget.partido.marcadorEquipo2.toString();
    }
  }

  void _guardarResultado() async {
    final goles1 = int.tryParse(_goles1Controller.text);
    final goles2 = int.tryParse(_goles2Controller.text);

    if (goles1 == null || goles2 == null) return;

    final partidoBox = Hive.box('partidos');
    final partidoActualizado = widget.partido
      ..marcadorEquipo1 = goles1
      ..marcadorEquipo2 = goles2;

    await partidoBox.put(partidoActualizado.id, partidoActualizado);

    Navigator.pop(context); // Volver al calendario
  }

  @override
  Widget build(BuildContext context) {
    final equipo1 = Hive.box('equipos').get(widget.partido.equipo1Id) as Equipo?;
    final equipo2 = Hive.box('equipos').get(widget.partido.equipo2Id) as Equipo?;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('${equipo1?.nombre ?? "Equipo 1"} vs ${equipo2?.nombre ?? "Equipo 2"}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _goles1Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: equipo1?.nombre ?? "Equipo 1"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _goles2Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: equipo2?.nombre ?? "Equipo 2"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardarResultado,
              child: const Text('Guardar Resultado'),
            ),
          ],
        ),
      ),
    );
  }
}
