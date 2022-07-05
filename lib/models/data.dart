import 'package:hive/hive.dart';

part 'data.g.dart';

@HiveType(typeId: 0)
class Data extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  bool isChecked = false;
  Data(this.title);
}
