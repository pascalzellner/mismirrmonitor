import 'dart:typed_data';

class BtleAnalyseService{
  
  bool isUint8Sensor(List<int> values){

    if(values.length==0){
      return null;
    }else{

    //on récupère le premier byte des 7 bytes du flag, premier chiffre de la série des values du data package
    var flag = values[0];
    var binaryFlag = flag.toRadixString(2);
    //on récupère le premier bit 0 qui définit si le device code le paquet en Uint8 ou Uint16
    List<String> binaryFlagArray = binaryFlag.split("");

    //le premier bit du package est le dernier de la collection, Bits are numbered from LSB (0) to MSB (7)
    if(binaryFlagArray[4].compareTo("0")==0){
      return true;
    }else{
      return false;
    }
    }
  }

  bool isUint16Sensor(List<int> values){

    if(values.length==0){
      return null;
    }else{

      //on récupère le byte 0, premier byte des 7 bytes du flag, premier chiffre de la série des values du data package
    var flag = values[0];
    var binaryFlag = flag.toRadixString(2);
    //on récupère le premier bit 0 qui définit si le device code le paquet en Uint8 ou Uint16
    List<String> binaryFlagArray = binaryFlag.split("");

    if(binaryFlagArray[4].compareTo("0")==1){
      return true;
    }else{
      return false;
    }
    }
  }

   //en fct du statut unint on récupérère le byte 1 (Unint8) ou les byte 1 et 2 (Uint16) du data package
  int getlastHearRateValue(List<int> values){

    if(values.length==0){

      return null;

    }else{

      if (isUint8Sensor(values)){
      return values[1].toInt();
    }else{
      if(isUint16Sensor(values)){
        
        var buffer = new Uint8List.fromList(values.sublist(1, 3)).buffer;
        var hrBuffer = new ByteData.view(buffer);
        return hrBuffer.getUint16(0, Endian.little);
      }else{
        return null;
      }
    }

    }
  }

  //si RR géré donne la liste des RR donnés
  List<int> rrData(List<int> values){

    List<int> result = [];
    switch(values.length){
      case 4:
      //il y a 4 bytes de rempli donc 1 RR qui est forcément en Uint16
      var buffer = new Uint8List.fromList(values.sublist(2, 4)).buffer;
      var rrBuffer = new ByteData.view(buffer);
      var rrvalue = rrBuffer.getUint16(0, Endian.little);
      rrvalue = ((rrvalue/1024)*1000).toInt();
      result.add(rrvalue);
      break;
      case 6:
      //il y a 6 bytes de rempli donc 2 RR qui est forcément en Uint16
      var buffer = new Uint8List.fromList(values.sublist(2, 4)).buffer;
      var rrBuffer = new ByteData.view(buffer);
      var rrvalue = rrBuffer.getUint16(0, Endian.little);
      rrvalue = ((rrvalue/1024)*1000).toInt();
      result.add(rrvalue);

      var bufferb = new Uint8List.fromList(values.sublist(4, 6)).buffer;
      var rrBufferb = new ByteData.view(bufferb);
      var rrvalueb = rrBufferb.getUint16(0, Endian.little);
      rrvalueb= ((rrvalueb/1024)*1000).toInt();
      result.add(rrvalueb);
      break;
      default:
      return [];
    }

    return result;

  }
  
}