import 'package:flutter/material.dart';
import 'archivos_exportados.dart';
// Importá tus otras pantallas aquí como:
// import 'torneos_page.dart';
// import 'calendario_partidos.dart';
// import 'tabla_posiciones.dart';

class MenuPrincipalPage extends StatelessWidget {
  const MenuPrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text('Torneos'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => TorneosPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Calendario de Partidos'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarioPartidosPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Tabla de Posiciones'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => TablaPosicionesPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Archivos Exportados'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ArchivosExportadosPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
