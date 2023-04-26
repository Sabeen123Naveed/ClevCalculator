import 'package:hive/hive.dart';
part 'modelclass.g.dart';
@HiveType(typeId: 0)
class Model{
  @HiveField(0)
  final String eventname;
  @HiveField(1)
  final String date;
  @HiveField(2)
  final String days;
  Model({required this.eventname, required this.date, required this.days});


}