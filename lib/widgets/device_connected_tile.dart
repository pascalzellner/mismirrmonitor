import 'package:mismirrmonitor/screen/monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectedDevicetile extends StatelessWidget {

  final BluetoothDevice device;
  ConnectedDevicetile({this.device});

  @override
  Widget build(BuildContext context) {

    device.discoverServices();

    return Card(
            child:Container(
              decoration: BoxDecoration(gradient: LinearGradient(
                colors: [Colors.pink[200],Colors.white],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
              )),
              child:Column(children: [
                ListTile(
                  leading: Icon(Icons.bluetooth_connected,color: Colors.pink[800],size:30.0,),
                  title: Text(device.name.toString()),
                  subtitle: Text(device.id.toString()),
                  trailing: IconButton(
                    icon:Icon(Icons.toggle_off,color:Colors.pink[800]),
                    tooltip: 'Déconnexion',
                    onPressed: () async {
                      device.disconnect();
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.help,color: Colors.grey[500],),
                  title: StreamBuilder<bool>(
                    stream:device.isDiscoveringServices,
                    initialData: false,
                    builder: (c,snapshot){
                      if(snapshot.data){
                        return Text('Chargement des services...',style: TextStyle(color: Colors.pink[800], fontSize: 12.0),);
                      }else{
                        return Text('Services chargés...',style: TextStyle(color: Colors.pink[900], fontSize: 12.0),);
                      }
                    },
                  ),
                  subtitle: StreamBuilder(
                    stream: device.services,
                    initialData: [],
                    builder: (c,snapshot){
                      int hrav=0;
                      for(var s in snapshot.data){
                        
                        bool isHeartService = s.uuid.toString().startsWith('0000180d');
                        if(isHeartService){
                          hrav=hrav+1;
                        }
                      }
                      if(hrav==1){
                        return Text(device.name.toString()+' : service HR/RR OK',style: TextStyle(color: Colors.pink[900], fontSize: 10.0),);
                      }else{
                        return Text(device.name.toString()+' : pas de service HR/RR',style: TextStyle(color: Colors.yellow[900], fontSize: 10.0),);
                      }
                    },
                  ),
                  trailing: StreamBuilder(
                    stream: device.services,
                    builder: (c,snapshot){
                      int hrav=0;
                      for(var s in snapshot.data){
                       
                        bool isHeartService = s.uuid.toString().startsWith('0000180d');
          
                        if(isHeartService){
                          hrav=hrav+1;
                        }
                      }
                      if(hrav==1){
                        return IconButton(
                          icon: Icon(Icons.add_circle,color: Colors.pink[900],), 
                          onPressed: (){
                          
                            // Sensor mySensor = Sensor(
                            //   uuidref: device.id.toString(),
                            //   name: device.name.toString(),
                            //   macaddress: device.id.toString(),
                            //   heartservice: 'OK',
                            //   heartcharacteristic: 'OK',
                            //   mtu: 23,
                            //   isActiv: true
                            // );
                            //SensorsRepository().addACtualSensor(mySensor);

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MonitorScreen(device: device,)));
                          }
                        );
                      }else{
                        return Icon(Icons.error_outline,color: Colors.yellow[200],);
                      }
                    },
                  ),
                ),
                SizedBox(height:10.0),
              ],)
            ),
          );
  }
}