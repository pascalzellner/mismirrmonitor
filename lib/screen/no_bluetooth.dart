import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BtleOffScreen extends StatelessWidget {

  final BluetoothState state;
  BtleOffScreen({this.state});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(gradient: LinearGradient(
          colors: [Colors.yellow[200],Colors.pink[200]],
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomLeft,
        ),),
        child: Center(child: Column(children: [
          SizedBox(height:150.0),
          Icon(Icons.bluetooth_disabled, size: 200.0,color: Colors.pink[800],),
          Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: TextStyle(fontSize: 12.0, color: Colors.black),
          ),
          SizedBox(height:10.0),
          Text('Vérifier et/ou Allumer le bluetooth',style: TextStyle(fontSize: 12.0,color: Colors.pink[900]),),
          Text('Pour Android vérifier et/ou allumer le GPS',style: TextStyle(fontSize: 12.0,color: Colors.pink[800]),),
          Text('v0.0.5.2',style: TextStyle(fontSize: 12.0,color: Colors.grey),)
        ],),),
      ),
    );

  }
}