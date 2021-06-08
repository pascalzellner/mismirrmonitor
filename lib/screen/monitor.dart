import 'package:mismirrmonitor/models/rrpoint.dart';
import 'package:mismirrmonitor/models/rrserie.dart';
import 'package:mismirrmonitor/screen/devices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mismirrmonitor/services/btle_analyse_service.dart';
import 'package:hive/hive.dart';
import 'package:mismirrmonitor/screen/series_screen.dart';


class MonitorScreen extends StatefulWidget {

  final BluetoothDevice device;
  MonitorScreen({this.device});
  
  @override
  _MonitorScreenState createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  @override
  Widget build(BuildContext context){

    final _formKey = GlobalKey<FormState>();

    bool _isRecording = false;
    bool _isPause = false;
    String _anonymat;
    String _position;

    Box<RRPoint> rrpoints = Hive.box<RRPoint>('RRPoints');
    Box<RRSerie> record = Hive.box<RRSerie>('RRSeries');

    
    //affichage de la confirmation d'enregistrement si ANNULER on clear la timeseries, si enregistrer on exporte ds hive puis on clear
    Future <void> _showRecordDialog() async {

      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Enregistrer',style:TextStyle(color: Colors.deepOrange[500])),
            content: Form(
              key:_formKey,
              child: Column(children:[
                SizedBox(height:10.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'N° Anonymat'),
                validator: (val) => val.isEmpty? 'Entrez numéro anonymat' : null,
                onChanged: (val){
                  setState(() {
                    _anonymat=val;
                  });
                },
              ),
              SizedBox(height:10.0),
              ]),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  rrpoints.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pas de sauvegarde...', style: TextStyle(fontSize: 12.0),),
                      duration: Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text('ANNULER', style: TextStyle(fontSize: 12.0,color: Colors.cyan[500]),),
              ),
              TextButton(
                onPressed: () async {
                  
                  //si ok pour enregistrer on va enregister dans Hive
                  RRSerie exam = RRSerie(name: _anonymat, dateTime: DateTime.now(), position: 'MISMIPROT');
                  List<RRPoint> actualRR = [];
                  for(var rr in rrpoints.values){
                    RRPoint newrr = RRPoint(rrvalue:rr.rrvalue);
                    actualRR.add(newrr);
                  }
                  exam.pointserie = actualRR;

                  record.add(exam);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enregistrement de la Série RR '+actualRR.length.toString()+ ' RR', style: TextStyle(fontSize: 12.0),),
                      duration: Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                  );

                  rrpoints.clear();
                  
                  Navigator.of(context).pop();
                },
                child: Text('ENREGISTRER', style: TextStyle(fontSize: 12.0,color: Colors.deepOrange[500]),),
              )
            ],

          );
        }
      );
    }
    
    

    return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.pink[900],
              actions: [
                TextButton.icon(
                  onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>SeriesScreen())), 
                  icon: Icon(Icons.list,color: Colors.white,),
                  label: Text('Examens',style: TextStyle(fontSize: 12.0,color: Colors.white),)
                ),
              ],
              title:Text('RR Monitor',style: TextStyle(fontSize: 12.0),),
            ),
            floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //on arrête l'enregistrement et on propose la sauvegarde
              FloatingActionButton(
                onPressed: () async {
                  if(_isRecording){
                    _isRecording=false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enregistrement stoppé', style: TextStyle(fontSize: 12.0),),
                      duration: Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                  );
                  _showRecordDialog();
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Rien à enregistrer !', style: TextStyle(fontSize: 12.0),),
                      duration: Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                  );
                  }
                },
                tooltip: 'Stop',
                child: Icon(Icons.stop),
                backgroundColor: Colors.pink[600],
              ),
              SizedBox(width: 10.0,),
              //mise en pause de l'enregistrement
              FloatingActionButton(
                onPressed: (){
                  print('pause');
                  _isPause=true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enregistrement en pause', style: TextStyle(fontSize: 12.0),),
                      duration: Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                  );
                },
                tooltip: 'Pause',
                child:Icon(Icons.pause),
                backgroundColor: Colors.yellow[800],
              ),
              SizedBox(width:10.0),
              //Lancer l'enregistrement des RR, reprendre l'enregistrement des RR
              FloatingActionButton(
                onPressed: (){
                  String _message;
                  print('Record');
                  if(_isPause){
                    _isPause=false;
                    _isRecording=true;
                    _message='Reprise Enregistrement';
                    //on relance aprés la pause on ne met pas de flag de début
                  }else{
                    _isRecording=true;
                    _message='Enregistrement';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_message, style: TextStyle(fontSize: 12.0),),
                      duration: Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                  );
                },
                tooltip: 'Record',
                child: Icon(Icons.not_started),
                backgroundColor: Colors.pink[900],
              ),  
            ],),
            body: Column(children: [
              SizedBox(height:5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=> DevicesScreen())), 
                    icon: Icon(Icons.bluetooth_connected,color: Colors.pink[500],), 
                    label: Text(widget.device.name, style: TextStyle(fontSize: 12.0, color: Colors.pink[500]),)
                  ),
                  StreamBuilder<List<BluetoothService>>(
                    stream: widget.device.services,
                    initialData: [],
                    builder: (c,snapshot){

                      int  nbS=0;
                      bool flagS=false;

                      if(snapshot.hasData){
                        for(var s in snapshot.data){

                          flagS = s.uuid.toString().startsWith('0000180d');
                          if(flagS){
                            
                            //on va rechercher le datapackage du service cardio
                            for(var c in s.characteristics){
                              
                              bool flagC = c.uuid.toString().startsWith('00002a37');
                              if(flagC){
                                nbS = nbS+1;
                              }
                            }
                          }
                        }
                        if(nbS==1){
                          return TextButton.icon(onPressed: (){}, icon: Icon(Icons.favorite,color: Colors.pink[500],), label: Text('HR/RR  ', style: TextStyle(fontSize: 12.0, color: Colors.pink[500]),));
                        }else{
                          return TextButton.icon(onPressed: (){}, icon: Icon(Icons.favorite_border,color: Colors.deepOrange[500],), label: Text('no HR/RR  ', style: TextStyle(fontSize: 12.0, color: Colors.pink[500]),));
                        }
                      
                      }else{
                        return TextButton.icon(
                          onPressed: (){}, 
                          icon: Icon(Icons.favorite,color: Colors.pink[500],), 
                          label: Text('Chargement...', style: TextStyle(fontSize: 12.0,color: Colors.pink[500]),)
                        );
                      }
                    }
                  ),
                ],
              ),
              Divider(),
              SizedBox(height:30.0),
              //affiche la fréquence cardiaque
              StreamBuilder<List<BluetoothService>>(
                stream: widget.device.services,
                initialData: [],
                builder:(c,snapshot){
                  for(var s in snapshot.data){
                    bool flagS = s.uuid.toString().startsWith('0000180d');
                    if(flagS){
                      for( var c in s.characteristics){
                        bool flagC = c.uuid.toString().startsWith('00002a37');
                        print('2A37 TROUVE');
                        if(flagC){
                          c.setNotifyValue(true);
                          return ListTile(
                            leading: Icon(Icons.favorite,color: Colors.pink[500],),
                            title:Text('HR',style: TextStyle(fontSize: 12.0,color: Colors.pink),),
                            subtitle: StreamBuilder<List<int>>(
                              stream: c.value,
                              initialData: [],
                              builder: (c,snapshot){
                                print('2A37 VALUE');
                                print(snapshot.data.toString());
                                if(snapshot.hasData){
                                  return Text(BtleAnalyseService().getlastHearRateValue(snapshot.data).toString(),style: TextStyle(fontSize:30.0,color:Colors.pink[500]),);
                                }else{
                                  return Text('.....',style: TextStyle(fontSize:30.0,color:Colors.pink[500]),);
                                }
                              }
                              )
                          );
                        }else{
                          return ListTile(
                            leading: Icon(Icons.favorite),
                            title:Text('HR',style: TextStyle(fontSize: 12.0,color: Colors.pink),),
                            subtitle: Text('non connecté',style: TextStyle(fontSize:30.0,color:Colors.pink[500]),),
                          );
                        }
                      }
                    }
                  }
                }
              ),
              SizedBox(height:10.0),
              //affiche les RR
              StreamBuilder<List<BluetoothService>>(
                stream: widget.device.services,
                initialData: [],
                builder:(c,snapshot){
                  for(var s in snapshot.data){
                    bool flagS = s.uuid.toString().startsWith('0000180d');
                    if(flagS){
                      for( var c in s.characteristics){
                        bool flagC = c.uuid.toString().startsWith('00002a37');
                        if(flagC){
                          
                          return ListTile(
                            leading: Icon(Icons.favorite,color: Colors.pink[500],),
                            title:Text('RR',style: TextStyle(fontSize: 12.0,color: Colors.pink),),
                            subtitle: StreamBuilder<List<int>>(
                              stream: c.value,
                              initialData: [],
                              builder: (c,snapshot){
                                if(snapshot.hasData){
                                  String value;
                                  try{
                                    value = BtleAnalyseService().rrData(snapshot.data)[0].toString();
                                    if(_isRecording){
                                    if(_isPause==false){
                                      print('record');
                                      for(var rr in BtleAnalyseService().rrData(snapshot.data)){
                                        print(rr.toString());
                                        rrpoints.add(RRPoint(rrvalue: rr));
                                      }
                                    }else{
                                      print('record_pause');
                                    }
                                  }
                                  }catch(e){
                                    value = '---';
                                  }
                                  return Text(value,style: TextStyle(fontSize:30.0,color:Colors.pink[500]),);
                                }else{
                                  return Text('.....',style: TextStyle(fontSize:30.0,color:Colors.pink[500]),);
                                }
                              }
                              )
                          );
                        }else{
                          return ListTile(
                            leading: Icon(Icons.favorite),
                            title:Text('RR',style: TextStyle(fontSize: 12.0,color: Colors.pink),),
                            subtitle: Text('non connecté',style: TextStyle(fontSize:30.0,color:Colors.pink[500]),),
                          );
                        }
                      }
                    }
                  }
                }
              ),
              Divider(),
            ],),
          );
  }
}