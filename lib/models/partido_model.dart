import 'package:hive/hive.dart';

part 'partido_model.g.dart';

@HiveType(typeId: 2)
class Partido extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String torneoId;

  @HiveField(2)
  String equipo1Id;

  @HiveField(3)
  String equipo2Id;

  @HiveField(4)
  DateTime fecha;

  @HiveField(5)
  String lugar;

  @HiveField(6)
  int? marcadorEquipo1;

  @HiveField(7)
  int? marcadorEquipo2;

  @HiveField(8)
  String fase;

  Partido({
    required this.id,
    required this.torneoId,
    required this.equipo1Id,
    required this.equipo2Id,
    required this.fecha,
    required this.lugar,
    this.marcadorEquipo1,
    this.marcadorEquipo2,
    required this.fase,
  });
}
