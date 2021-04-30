import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DisconnectedDeviceTile extends StatelessWidget {

  final BluetoothDevice device;
  DisconnectedDeviceTile({this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
            child:Container(
              decoration: BoxDecoration(gradient: LinearGradient(
                colors: [Colors.yellow[200],Colors.white],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
              )),
              child:Column(children: [
                ListTile(
                  onTap: (){},
                  leading: Icon(Icons.bluetooth_disabled,color: Colors.pink[800],),
                  title:Text(device.id.toString()),
                  subtitle: Text(device.name.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.toggle_on,color:Colors.pink[800]),
                    tooltip: 'Connecter',
                    onPressed: () async {
                      await device.connect();
                      await device.discoverServices();
                    },
                  ),
                ),
              ],)
            ),
          );
  }
}