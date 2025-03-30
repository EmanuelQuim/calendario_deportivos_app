// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partido_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartidoAdapter extends TypeAdapter<Partido> {
  @override
  final int typeId = 2;

  @override
  Partido read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Partido(
      id: fields[0] as String,
      torneoId: fields[1] as String,
      equipo1Id: fields[2] as String,
      equipo2Id: fields[3] as String,
      fecha: fields[4] as DateTime,
      lugar: fields[5] as String,
      marcadorEquipo1: fields[6] as int?,
      marcadorEquipo2: fields[7] as int?,
      fase: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Partido obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.torneoId)
      ..writeByte(2)
      ..write(obj.equipo1Id)
      ..writeByte(3)
      ..write(obj.equipo2Id)
      ..writeByte(4)
      ..write(obj.fecha)
      ..writeByte(5)
      ..write(obj.lugar)
      ..writeByte(6)
      ..write(obj.marcadorEquipo1)
      ..writeByte(7)
      ..write(obj.marcadorEquipo2)
      ..writeByte(8)
      ..write(obj.fase);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartidoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
