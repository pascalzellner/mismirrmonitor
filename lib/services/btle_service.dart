import 'package:flutter_blue/flutter_blue.dart';
import 'package:mismirrmonitor/models/sensor.dart';

class BtleService{


  Future<BluetoothDevice>connectRefDeviceByUuid(String sensorUuid) async {

    print('Recherche capteur');

    bool _flag=false;
    BluetoothDevice device;

    FlutterBlue.instance.startScan(timeout:Duration(seconds: 4));
    FlutterBlue.instance.scanResults.listen((results) { 

      for (var r in results){
        print(r.device.id.toString());
        print(r.device.name.toString());
        if(r.device.id.toString().compareTo(sensorUuid)==0){
          print('DEVICE TROUVEE');
          _flag=true;
          device = r.device;
          print(_flag);
        }
      }
    });

    FlutterBlue.instance.stopScan();
  
    return device;
  }

  Future<BluetoothDevice> getConnectedDeviceByName(String sensorName) async {

  BluetoothDevice actualDevice;
  bool flag = false;
  List<BluetoothDevice> devices = await FlutterBlue.instance.connectedDevices;

  for(var d in devices){
    if(d.name.toString().compareTo(sensorName)==0){
      flag = true;
      actualDevice = d;
    }
    if(flag){
      return actualDevice;
    }else{
      return null;
    }
  }
 }

 Future<BluetoothService> getDeviceCardioServices(BluetoothDevice device) async {

   BluetoothService service;
   bool flag = false;
   List<BluetoothService> services = await device.discoverServices();
   for(var s in services){
     if(s.uuid.toString().startsWith('0000180d')==true){
       flag=true;
       service = s;
     }
     if(flag){
       return service;
     }else{
       return null;
     }
   }
 }

 Future<BluetoothCharacteristic> getHRRRCharecteristic(BluetoothService service) async {

   BluetoothCharacteristic characteristic;
   bool flag = false;
   List<BluetoothCharacteristic> characteristics = service.characteristics;
   for(var c in characteristics){
     if(c.uuid.toString().startsWith('00002a37')==true){
       flag=true;
       characteristic = c;
     }
     if(flag){
       return characteristic;
     }else{
       return null;
     }
   }
 }
}