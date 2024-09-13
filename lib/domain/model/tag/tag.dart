import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 2)
class Tag {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String sid;

  Tag(
    this.name,
    this.sid,
  );

  Tag.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        sid = map['sid'];
}
