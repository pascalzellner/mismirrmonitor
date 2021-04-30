// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rrserie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RRSerieAdapter extends TypeAdapter<RRSerie> {
  @override
  final int typeId = 2;

  @override
  RRSerie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RRSerie(
      name: fields[0] as String,
      position: fields[1] as String,
      dateTime: fields[2] as DateTime,
    )..pointserie = (fields[3] as List)?.cast<RRPoint>();
  }

  @override
  void write(BinaryWriter writer, RRSerie obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.pointserie);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RRSerieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
