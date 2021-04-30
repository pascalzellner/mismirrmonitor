import 'package:mismirrmonitor/widgets/device_connected_tile.dart';
import 'package:mismirrmonitor/widgets/device_disconnected_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ScanDeviceTile extends StatelessWidget {

  final BluetoothDevice device;
  ScanDeviceTile({this.device});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>
    (
      stream: device.state,
      initialData: BluetoothDeviceState.disconnected,
      builder: (c,snapshot){
        switch(snapshot.data){
          case BluetoothDeviceState.connected:
          return ConnectedDevicetile(device: device,);
          break;
          //case BluetoothDeviceState.connecting:
          //return ConnectedDevicetile();
          //break;
          case BluetoothDeviceState.disconnected:
          return DisconnectedDeviceTile(device: device,);
          break;
          //case BluetoothDeviceState.disconnecting:
          //return DisconnectedDeviceTile();
          //break;
          default:
          return DisconnectedDeviceTile();
        }
      }
    );
}
}