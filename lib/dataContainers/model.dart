import 'dart:convert';
import 'dart:math';

import '../app/task.dart';
import 'localDatabase.dart';

class Model {
  List<Task> _tasks = [];
  late LocalDatabase _localDatabase;
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

  Future<void> init() async {
    _localDatabase = LocalDatabase();
    await _localDatabase.init();
    var jsonTasks = _localDatabase.getFromDB();
    int lastId = 0;
    int cnt = 0;
    int compcCount = 0;
    List<Task> tmp = [];
    if (jsonTasks != null) {
      _tasks = jsonTasks.map((e) => Task.fromJson(json.decode(e))).toList()
          as List<Task>;
      cnt = _tasks.length;
      for (int i = 0; i < _tasks.length; i++) {
        tmp.add(Task.fromJson(json.decode(jsonTasks[i])));
        if (tmp[i].completed) {
          compcCount++;
        }
        lastId = max(lastId, tmp[i].id);
      }
      _completedCnt = compcCount;
      _count = cnt;
      _lastId = lastId + 1;
    }
  }

  void saveToLocal() {
    _localDatabase
        .writeToDB(_tasks.map((e) => jsonEncode(e.toJson())).toList());
  }

  void addTask(String action, String priority, String period, bool completed,
      DateTime? deadline) {
    _tasks.add(Task(
        action: action,
        priority: priority,
        period: period,
        completed: completed,
        id: _lastId,
        deadline: deadline));
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

  void changeTask(Task task, String action, String priority, String period,
      DateTime? deadline) {
    for (int i = 0; i < count; i++) {
      if (_tasks[i].id == task.id) {
        _tasks[i].action = action;
        _tasks[i].priority = priority;
        _tasks[i].period = period;
        _tasks[i].deadline = deadline;
      }
    }
  }
}
