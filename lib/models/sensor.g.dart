// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensorAdapter extends TypeAdapter<Sensor> {
  @override
  final int typeId = 1;

  @override
  Sensor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sensor(
      name: fields[1] as String,
      uuidref: fields[0] as String,
      macaddress: fields[2] as String,
      heartservice: fields[3] as String,
      heartcharacteristic: fields[4] as String,
      mtu: fields[5] as int,
      isActiv: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Sensor obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uuidref)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.macaddress)
      ..writeByte(3)
      ..write(obj.heartservice)
      ..writeByte(4)
      ..write(obj.heartcharacteristic)
      ..writeByte(5)
      ..write(obj.mtu)
      ..writeByte(6)
      ..write(obj.isActiv);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
