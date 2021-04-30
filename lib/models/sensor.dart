import 'package:hive/hive.dart';

part 'sensor.g.dart';

@HiveType(typeId: 1)
class Sensor extends HiveObject{

  @HiveField(0)
  String uuidref;
  @HiveField(1)
  String name;
  @HiveField(2)
  String macaddress;
  @HiveField(3)
  String heartservice;
  @HiveField(4)
  String heartcharacteristic;
  @HiveField(5)
  int mtu;
  @HiveField(6)
  bool isActiv;

  Sensor({this.name,this.uuidref,this.macaddress,this.heartservice,this.heartcharacteristic,this.mtu,this.isActiv});
}

// class SensorAdapter extends TypeAdapter<Sensor>{
//   @override
//   Sensor read(BinaryReader reader) {
//      return Sensor().uuidref = reader.read();
//     }
  
//     @override
//     final typeId = 0;
  
//     @override
//     void write(BinaryWriter writer, Sensor obj) {
//     writer.write(obj.name);
//   }

//}