import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/torneo_model.dart';
import 'crear_torneo.dart';



class TorneosPage extends StatefulWidget {
  const TorneosPage({super.key});

  @override
  State<TorneosPage> createState() => _TorneosPageState();
}

class _TorneosPageState extends State<TorneosPage> {
  late Box torneosBox;

  @override
  void initState() {
    super.initState();
    torneosBox = Hive.box('torneos'); // Asegúrate de que la caja esté abierta
  }

  void _eliminarTorneo(String id) async {
    await torneosBox.delete(id); // Elimina el torneo
    setState(() {}); // Refresca la lista
  }

  @override
  Widget build(BuildContext context) {
    final torneos = torneosBox.values.cast<Torneo>().toList(); // Obtiene la lista de torneos

    return Scaffold(
      appBar: AppBar(title: const Text('Torneos Guardados')),
      body: torneos.isEmpty
          ? const Center(child: Text('No hay torneos guardados')) // Muestra mensaje si no hay torneos
          : ListView.builder(
              itemCount: torneos.length,
              itemBuilder: (context, index) {
                final torneo = torneos[index];
                return ListTile(
                  title: Text(torneo.nombre),
                  subtitle: Text(
                    'Del ${torneo.fechaInicio.day}/${torneo.fechaInicio.month} '
                    'al ${torneo.fechaFin.day}/${torneo.fechaFin.month}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarTorneo(torneo.id), // Elimina el torneo
                  ),
                  onTap: () {
                    // Aquí puedes agregar la navegación para el detalle del torneo
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearTorneoPage()),
          ).then((_) => setState(() {})); // Refresca la pantalla después de agregar un nuevo torneo
        },
        
        tooltip: 'Crear nuevo torneo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
