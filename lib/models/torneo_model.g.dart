// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'torneo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TorneoAdapter extends TypeAdapter<Torneo> {
  @override
  final int typeId = 0;

  @override
  Torneo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Torneo(
      id: fields[0] as String,
      nombre: fields[1] as String,
      fechaInicio: fields[2] as DateTime,
      fechaFin: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Torneo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.fechaInicio)
      ..writeByte(3)
      ..write(obj.fechaFin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TorneoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
