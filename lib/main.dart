import 'package:mismirrmonitor/models/rrpoint.dart';
import 'package:mismirrmonitor/models/rrserie.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mismirrmonitor/screen/devices_screen.dart';
import 'package:mismirrmonitor/screen/no_bluetooth.dart';
import 'models/sensor.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(SensorAdapter());
  Hive.registerAdapter(RRPointAdapter());
  Hive.registerAdapter(RRSerieAdapter());
  await Hive.openBox<Sensor>('sensors');
  await Hive.openBox<RRSerie>('RRseries');
  await Hive.openBox<RRPoint>('RRpoints');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MisMi RR Monitor',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.off,
      builder: (c,snapshot){
        final state = snapshot.data;
        if(state==BluetoothState.on){
          return DevicesScreen();
        }else{
          return BtleOffScreen();
        }

      }
    );
  }

  @override
  void dispose(){

    Hive.box('sensors').close();
    Hive.box('RRseries').close();
    Hive.box('RRpoints').close();

    Hive.close();
    super.dispose();
  }
}
