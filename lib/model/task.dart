class Task {
  int id;
  String action;
  String priority;
  bool completed;
  String period;
  Task(
      {required this.action,
      required this.priority,
      required this.period,
      required this.completed,
      required this.id});
}
