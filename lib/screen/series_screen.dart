import 'package:mismirrmonitor/models/rrserie.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mismirrmonitor/services/export_txt.dart';
import 'package:mismirrmonitor/services/mail_service.dart';



class SeriesScreen extends StatelessWidget {
  const SeriesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Box<RRSerie> rreseriesBox = Hive.box<RRSerie>('RRSeries');

      return Scaffold(
        appBar: AppBar(
          title: Text('Enregistrements', style:TextStyle(fontSize: 12.0)),
          backgroundColor: Colors.pink[800],
        ),
        body: ValueListenableBuilder(
          valueListenable: rreseriesBox.listenable(),
          builder: (context,rrseriesBox,widget){
            return ListView.builder(
              itemCount: rreseriesBox.length,
              itemBuilder: (BuildContext context, int index){

                final serie = rreseriesBox.getAt(index);

                return Card(
                  child: Container(
                    decoration: BoxDecoration(gradient: LinearGradient(
                      colors: [Colors.cyan[100],Colors.white],
                      begin: FractionalOffset.topRight,
                      end: FractionalOffset.bottomLeft,
                    )),
                    child: Column(children:[
                      ListTile(
                        leading: Icon(Icons.description,color: Colors.cyan[500],),
                        title:Text(serie.name+" / "+serie.position+ " - "+serie.pointserie.length.toString()+" RR",style:TextStyle(fontSize: 12.0,color: Colors.cyan[500])),
                        subtitle: Text(serie.dateTime.toString(),style: TextStyle(fontSize: 10.0,color: Colors.grey),),
                        trailing:IconButton(
                          icon: Icon(Icons.delete,color: Colors.grey,),
                          tooltip: 'Supprimer',
                          onPressed: ()=>rreseriesBox.deleteAt(index),
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: ()async {
                              await ExportTxtService().writeData(serie.name, serie.pointserie, serie.dateTime.day.toString());
                              String path = await ExportTxtService().getDirPath();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Export réalisé: '+path, style: TextStyle(fontSize: 12.0),),
                                  duration: Duration(milliseconds: 5000),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                                ),
                              );
                            }, 
                            icon: Icon(Icons.file_upload,color: Colors.deepOrange[500],), 
                            label: Text('EXPORTER',style: TextStyle(color: Colors.cyan[500]),)
                          ),
                          TextButton.icon(
                            onPressed: (){}, 
                            icon: Icon(Icons.fingerprint,color: Colors.deepOrange[500],), 
                            label: Text('ANALYSER',style: TextStyle(color: Colors.cyan[500]),)
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              try{
                                await MailService().sendRRExam(serie.name+serie.dateTime.day.toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Examen envoyé', style: TextStyle(fontSize: 12.0),),
                                  duration: Duration(milliseconds: 5000),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                                ),
                              );
                              }catch(e){
                                 ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Echec mail: '+e.toString(), style: TextStyle(fontSize: 12.0),),
                                  duration: Duration(milliseconds: 5000),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.deepOrange[500],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                                ),
                              );
                              }
                            }, 
                            icon: Icon(Icons.mail,color: Colors.deepOrange[400],), 
                            label: Text('ENVOYER',style: TextStyle(color: Colors.cyan[500]),)
                          ),
                        ],
                      ),
                    ]),
                  ),
                );

              }
            );
          },
        ),
      );

  }
}
