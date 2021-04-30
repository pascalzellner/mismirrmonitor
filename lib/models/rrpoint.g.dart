// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rrpoint.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RRPointAdapter extends TypeAdapter<RRPoint> {
  @override
  final int typeId = 3;

  @override
  RRPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RRPoint(
      rrvalue: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RRPoint obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.rrvalue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RRPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
