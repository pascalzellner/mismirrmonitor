import 'package:hive/hive.dart';
import 'package:mismirrmonitor/models/rrpoint.dart';

part 'rrserie.g.dart';


@HiveType(typeId: 2)
class RRSerie{

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String position;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  List<RRPoint> pointserie;

  RRSerie({this.name,this.position,this.dateTime});


}