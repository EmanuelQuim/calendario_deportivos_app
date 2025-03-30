import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'models/torneo_model.dart';
import 'screens/menu_principal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializamos Hive en la ruta del dispositivo
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Registramos los adaptadores de Hive
  Hive.registerAdapter(TorneoAdapter());

  // Abrimos la caja de 'torneos' para poder leer/escribir en ella
  await Hive.openBox('torneos');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario Deportivo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MenuPrincipalPage(),
    );
  }
}
