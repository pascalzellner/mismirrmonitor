import 'package:hive/hive.dart';

part 'rrpoint.g.dart';

@HiveType(typeId: 3)
class RRPoint{

  @HiveField(0)
  final int rrvalue;

  RRPoint({this.rrvalue});

}