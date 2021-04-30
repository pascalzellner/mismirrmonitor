import 'package:mismirrmonitor/screen/series_screen.dart';
import 'package:mismirrmonitor/widgets/device_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DevicesScreen extends StatefulWidget {
  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détection des capteurs',style: TextStyle(fontSize: 14.0),),
        backgroundColor: Colors.pink[800],
        actions: [
          TextButton.icon(
            onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>SeriesScreen())), 
            icon: Icon(Icons.list,color: Colors.white,),
            label: Text('Examens',style: TextStyle(fontSize: 12.0,color: Colors.white),)
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream : FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c,snapshot){
          if(snapshot.data){
            return FloatingActionButton(
              onPressed: ()=>FlutterBlue.instance.stopScan(),
              tooltip: 'Stop Scanning',
              child: Icon(Icons.stop),
              backgroundColor: Colors.pink[700],
            );
          }else{
            return FloatingActionButton(
              onPressed: ()=>FlutterBlue.instance.startScan(timeout:Duration(seconds: 4)),
              tooltip: 'Start Scanning',
              child: Icon(Icons.bluetooth),
              backgroundColor: Colors.yellow[700],
            );
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: ()=>FlutterBlue.instance.startScan(timeout:Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(children: [
            //affiche les devices cardio déjà listé
            //affiche les devices non connectés
            StreamBuilder<List<ScanResult>>(
              stream:FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c,snapshot)=>Column(
                children:snapshot.data.map((r) => ScanDeviceTile(device:r.device)).toList(),
              )
            ),
          ],),
        ),
      ),
    );
  }
}