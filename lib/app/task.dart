class Task {
  int id;
  String action;
  String priority;
  bool completed;
  String period;
  DateTime? deadline;

  Task(
      {required this.action,
      required this.priority,
      required this.period,
      required this.completed,
      required this.id,
      this.deadline});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: int.parse(json["element"]["id"]),
        action: json["element"]["text"],
        priority: json["element"]["importance"],
        deadline: json["element"]["deadline"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["element"]["deadline"]),
        period: "1234",
        completed: bool.parse(json["element"]["done"]),
      );

  Map<String, dynamic> toJson() => {
        "status": "ok",
        "element": {
          "id": id.toString(),
          // уникальный идентификатор элемента STRING
          "text": action,
          // STRING
          "importance": priority,
          // importance = low | basic | important STRING
          "deadline": deadline == null
              ? null
              : deadline!.toUtc().millisecondsSinceEpoch,
          // int64, может отсутствовать, тогда нет INT
          "done": completed.toString(),
          // BOOL
          "color": "",
          // может отсутствовать STRING
          "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          // INT
          "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          // INT
          "last_updated_by": "iphone",
          // STRING
        },
      };
}
