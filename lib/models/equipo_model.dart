import 'package:hive/hive.dart';

part 'equipo_model.g.dart';

@HiveType(typeId: 1)
class Equipo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  String torneoId;

  @HiveField(3)
  String? logo;

  Equipo({
    required this.id,
    required this.nombre,
    required this.torneoId,
    this.logo,
  });
}
