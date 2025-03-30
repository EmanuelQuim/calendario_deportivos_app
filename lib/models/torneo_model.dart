import 'package:hive/hive.dart';

part 'torneo_model.g.dart';

@HiveType(typeId: 0)
class Torneo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  DateTime fechaInicio;

  @HiveField(3)
  DateTime fechaFin;

  Torneo({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
  });
}
