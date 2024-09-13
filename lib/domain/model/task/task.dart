import 'package:estesis_tech/domain/model/tag/tag.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String sid;
  @HiveField(1)
  final bool isDone;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String? finishAt;
  @HiveField(4)
  final int? priority;
  @HiveField(5)
  final Tag tag;
  @HiveField(6)
  final String text;

  Task({
    required this.tag,
    required this.sid,
    required this.isDone,
    required this.title,
    required this.text,
    this.finishAt,
    this.priority,
  });

  Task.fromMap(Map<String, dynamic> map)
      : sid = map['sid'],
        isDone = map['isDone'],
        title = map['title'],
        finishAt = map['finishAt'],
        tag = Tag.fromMap(map['tag']),
        priority = map['priority'],
        text = map['text'];
}
