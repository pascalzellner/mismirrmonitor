import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class BleService{

  final BleManager bleManager = BleManager();
  bool _initialized = false;

  Future initManager() async{
   await bleManager.createClient();
   _initialized=true;
  }

  BleManager getBleManager(){
    return bleManager;
  }


}

