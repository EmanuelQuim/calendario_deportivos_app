// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipoAdapter extends TypeAdapter<Equipo> {
  @override
  final int typeId = 1;

  @override
  Equipo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Equipo(
      id: fields[0] as String,
      nombre: fields[1] as String,
      torneoId: fields[2] as String,
      logo: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Equipo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.torneoId)
      ..writeByte(3)
      ..write(obj.logo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
