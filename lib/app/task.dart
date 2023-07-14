import 'package:uuid/uuid.dart';

class Task {
  String? id;
  String action;
  String priority;
  bool completed;
  String period;
  DateTime? deadline;

  Task({
    this.id,
    required this.action,
    required this.priority,
    required this.period,
    required this.completed,
    this.deadline,
  }) {
    id ??= const Uuid().v4();
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        action: json["text"],
        priority: json["importance"],
        deadline: json["deadline"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["deadline"]),
        period: "1234",
        completed: json["done"],
      );

  Map<String, dynamic> toJson() => (deadline == null)
      ? {
          "id": id,
          // уникальный идентификатор элемента STRING
          "text": action,
          // STRING
          "importance": priority,
          // importance = low | basic | important STRING
          "done": completed,
          // BOOL
          "color": "#FFFFFF",
          // может отсутствовать STRING
          "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          // INT
          "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          // INT
          "last_updated_by": "iphone",
          // STRING
        }
      : {
          "id": id,
          // уникальный идентификатор элемента STRING
          "text": action,
          // STRING
          "importance": priority,
          // importance = low | basic | important STRING
          "deadline": deadline!.toUtc().millisecondsSinceEpoch,
          // int64, может отсутствовать, тогда нет INT
          "done": completed,
          // BOOL
          "color": "#FFFFFF",
          // может отсутствовать STRING
          "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          // INT
          "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          // INT
          "last_updated_by": "iphone",
          // STRING
        };
}
