import 'package:flutter/material.dart';
import 'screens/menu_principal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Asegurate de inicializar Hive y abrir boxes aquí
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
