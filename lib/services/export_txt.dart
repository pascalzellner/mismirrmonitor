import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mismirrmonitor/models/rrpoint.dart';

class ExportTxtService{

  // Find the Documents path
  Future<String> getDirPath() async {
    final _dir = await getExternalStorageDirectory();
    print(_dir);
    return _dir.path;
  }

  Future<void> writeData(String anom, List<RRPoint>serie, String date) async {
    final _dirPath = await getDirPath();
    
    final _myFile = File('$_dirPath/$anom$date.txt');
    // If data.txt doesn't exist, it will be created automatically
    
    String serieValues = '';
    int _index=1;

    for (var rr in serie){
      if(_index==1){
        serieValues = serieValues+rr.rrvalue.toString();
        _index=_index+1;
      }else{
        serieValues = serieValues+" "+rr.rrvalue.toString(); 
      }
      
      
    }

    await _myFile.writeAsString(serieValues);
}
}