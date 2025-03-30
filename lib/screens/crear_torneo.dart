import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/torneo_model.dart';

class CrearTorneoPage extends StatefulWidget {
  const CrearTorneoPage({super.key});

  @override
  State<CrearTorneoPage> createState() => _CrearTorneoPageState();
}

class _CrearTorneoPageState extends State<CrearTorneoPage> {
  final TextEditingController _nombreController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  void _guardarTorneo() async {
    if (_nombreController.text.isEmpty || _fechaInicio == null || _fechaFin == null) return;

    final torneo = Torneo(
      id: const Uuid().v4(),
      nombre: _nombreController.text,
      fechaInicio: _fechaInicio!,
      fechaFin: _fechaFin!,
    );

    final box = Hive.box('torneos');
    await box.put(torneo.id, torneo);

    Navigator.pop(context);
  }

  Future<void> _seleccionarFechaInicio() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (fecha != null) {
      setState(() {
        _fechaInicio = fecha;
      });
    }
  }

  Future<void> _seleccionarFechaFin() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: _fechaInicio ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (fecha != null) {
      setState(() {
        _fechaFin = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Torneo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del torneo'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(_fechaInicio == null
                    ? 'Fecha de inicio'
                    : 'Inicio: ${_fechaInicio!.toLocal()}'.split(' ')[0]),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _seleccionarFechaInicio,
                  child: const Text('Seleccionar'),
                ),
              ],
            ),
            Row(
              children: [
                Text(_fechaFin == null
                    ? 'Fecha de fin'
                    : 'Fin: ${_fechaFin!.toLocal()}'.split(' ')[0]),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _seleccionarFechaFin,
                  child: const Text('Seleccionar'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardarTorneo,
              child: const Text('Guardar Torneo'),
            ),
          ],
        ),
      ),
    );
  }
  
}


