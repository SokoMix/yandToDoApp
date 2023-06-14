import 'task.dart';

class Model {
  final List<Task> _tasks = [];
  int _lastId = 0;
  int _count = 0;
  bool _isHide = false;
  int _completedCnt = 0;
  int get count => _count;
  List<Task> get tasks => _tasks;
  int get completedCnt => _completedCnt;
  bool get isHide => _isHide;
  set isHide(bool value) {
    _isHide = value;
  }

  void addTask(String action, String priority, String period, bool completed) {
    _tasks.add(Task(
        action: action,
        priority: priority,
        period: period,
        completed: completed,
        id: _lastId));
    _lastId += 1;
    _count += 1;
  }

  void addCompleted() {
    _completedCnt += 1;
  }

  void delCompleted() {
    _completedCnt -= 1;
  }

  void deleteTask(int id) {
    _tasks.removeWhere((element) {
      if (element.id == id && element.completed) {
        _completedCnt -= 1;
      }
      return element.id == id;
    });
    _count -= 1;
  }

  void setComp(int id) {
    for (int i = 0; i < _count; i++) {
      if (id == _tasks[i].id) {
        _tasks[i].completed = !_tasks[i].completed;
      }
    }
  }

  void changeTask(Task task, String action, String priority, String period) {
    for (int i = 0; i < count; i++) {
      if (_tasks[i].id == task.id) {
        _tasks[i].action = action;
        _tasks[i].priority = priority;
        _tasks[i].period = period;
      }
    }
  }
}
