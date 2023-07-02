import 'dart:convert';
import 'dart:math';
import 'package:yandex_todo/API/toDoAPI.dart';
import '../app/task.dart';
import 'localDatabase.dart';

class Model {
  List<Task> _tasks = [];
  late LocalDatabase _localDatabase;
  final _toDoAPI = ToDoAPI();
  int _count = 0;
  bool _isHide = false;
  int _completedCnt = 0;
  int _revision = 0;

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
    final apiRequest = await _toDoAPI.getAllTasks();
    final int apiRev = await _toDoAPI.getRevision() ?? 0;
    final apiDBData = apiRequest;
    final localDBRequest = _localDatabase.getFromDB();
    final int localRev = localDBRequest.$2 ?? 0;
    final localDBData = localDBRequest.$1;
    int cnt = 0;
    int compCount = 0;
    List<Task> tmp = [];
    _revision = max(localRev, apiRev);
    if ((localDBData != null && apiDBData == null) || (localDBData != null && apiDBData != null && localRev >= apiRev)) {
      _tasks = localDBData.map((e) => Task.fromJson(json.decode(e))).toList();
      cnt = _tasks.length;
      for (int i = 0; i < _tasks.length; i++) {
        tmp.add(Task.fromJson(json.decode(localDBData[i])));
        if (tmp[i].completed) {
          compCount++;
        }
      }
      _completedCnt = compCount;
      _count = cnt;
      _toDoAPI.refreshAll(_tasks.map((e) => (e.toJson())).toList(), _revision);
      _revision++;
    }
    else if ((localDBData == null && apiDBData != null) || (localDBData != null && apiDBData != null && localRev < apiRev))
      {
        _tasks = apiDBData.map((e) => Task.fromJson(e)).toList();
        _count = _tasks.length;
        for (int i = 0; i < _tasks.length; i++)
          {
            if (_tasks[i].completed) {
              compCount++;
            }
          }
        _completedCnt = compCount;
        saveToLocal();
      }
  }

  void saveToLocal() {
    _localDatabase
        .writeToDB(_tasks.map((e) => jsonEncode(e.toJson())).toList(), _revision);
  }

  void addTask(String action, String priority, String period, bool completed,
      DateTime? deadline) {
    _tasks.add(Task(
        action: action,
        priority: priority,
        period: period,
        completed: completed,
        deadline: deadline));
    _toDoAPI.addTask(_tasks[_count].toJson(), _revision);
    _revision++;
    _count += 1;
  }

  void addCompleted() {
    _completedCnt += 1;
  }

  void delCompleted() {
    _completedCnt -= 1;
  }

  void deleteTask(String? id) {
    _tasks.removeWhere((element) {
      if (element.id == id && element.completed) {
        _completedCnt -= 1;
      }
      return element.id == id;
    },);
    _toDoAPI.deleteTask(id!, _revision);
    _revision++;
    _count -= 1;
  }

  void setComp(String? id) {
    int ind = 0;
    for (int i = 0; i < _count; i++) {
      if (id == _tasks[i].id) {
        _tasks[i].completed = !_tasks[i].completed;
        ind = i;
      }
    }
    _toDoAPI.refreshTask(id!, _tasks[ind].toJson(), _revision);
    _revision++;
  }

  void changeTask(Task task, String action, String priority, String period,
      DateTime? deadline) {
    int ind = 0;
    for (int i = 0; i < count; i++) {
      if (_tasks[i].id == task.id) {
        _tasks[i].action = action;
        _tasks[i].priority = priority;
        _tasks[i].period = period;
        _tasks[i].deadline = deadline;
        ind = i;
      }
    }
    _toDoAPI.refreshTask(task.id!, _tasks[ind].toJson(), _revision);
    _revision++;
  }
}
