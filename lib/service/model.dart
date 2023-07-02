import 'dart:convert';
import 'dart:math';
import 'package:yandex_todo/API/toDoAPI.dart';
import '../app/task.dart';
import '../API/localDatabaseAPI.dart';

class Model {
  List<Task> _tasks = [];
  late LocalDatabase _localDatabase;
  late ToDoAPI _toDoAPI;
  int _count = 0;
  int _completedCnt = 0;
  int _revision = 0;

  Model();

  int get count => _count;

  List<Task> get tasks => _tasks;

  int get completedCnt => _completedCnt;

  Future<void> init(LocalDatabase ld, ToDoAPI nd) async {
    _localDatabase = ld;
    _toDoAPI = nd;
    final localDBRequest = _localDatabase.getFromDB();
    final int localRev = localDBRequest.$2 ?? 0;
    final localDBData = localDBRequest.$1;
    int cnt = 0;
    List<Task> tmp = [];
    if (localDBData != null) {
      _tasks = localDBData.map((e) => Task.fromJson(json.decode(e))).toList();
      cnt = _tasks.length;
      int compCount = 0;
      for (int i = 0; i < _tasks.length; i++) {
        tmp.add(Task.fromJson(json.decode(localDBData[i])));
        if (tmp[i].completed) {
          compCount++;
        }
      }
      _completedCnt = compCount;
      _count = cnt;
    }
    final int apiRev = await _toDoAPI.getRevision() ?? 0;
    final apiDBData = await _toDoAPI.getAllTasks();
    _revision = max(localRev, apiRev);
    if ((localDBData != null && apiDBData == null) ||
        (localDBData != null && apiDBData != null && localRev >= apiRev)) {
      final isUpdate = await _toDoAPI.refreshAll(
          _tasks.map((e) => (e.toJson())).toList(), _revision);
      if (isUpdate) {
        _revision = max(_revision, await _toDoAPI.getRevision() ?? -1);
        _toDoAPI.refreshAll(
            _tasks.map((e) => (e.toJson())).toList(), _revision);
      }
      _revision++;
    } else if ((localDBData == null && apiDBData != null) ||
        (localDBData != null && apiDBData != null && localRev < apiRev)) {
      _tasks = apiDBData.map((e) => Task.fromJson(e)).toList();
      _count = _tasks.length;
      int compCount = 0;
      for (int i = 0; i < _tasks.length; i++) {
        if (_tasks[i].completed) {
          compCount++;
        }
      }
      _completedCnt = compCount;
      saveToLocal();
    }
  }

  void saveToLocal() {
    _localDatabase.writeToDB(
        _tasks.map((e) => jsonEncode(e.toJson())).toList(), _revision);
  }

  Future<void> addTask(String action, String priority, String period,
      bool completed, DateTime? deadline) async {
    _tasks.add(Task(
        action: action,
        priority: priority,
        period: period,
        completed: completed,
        deadline: deadline));
    final isUpdate = await _toDoAPI.addTask(_tasks[_count].toJson(), _revision);
    if (isUpdate) {
      _revision = max(_revision, await _toDoAPI.getRevision() ?? -1);
      _toDoAPI.addTask(_tasks[_count].toJson(), _revision);
    }
    _revision++;
    _count += 1;
  }

  void addCompleted() {
    _completedCnt += 1;
  }

  void delCompleted() {
    _completedCnt -= 1;
  }

  Future deleteTask(String? id) async {
    _tasks.removeWhere(
      (element) {
        if (element.id == id && element.completed) {
          _completedCnt -= 1;
        }
        return element.id == id;
      },
    );
    final isUpdate = await _toDoAPI.deleteTask(id!, _revision);
    if (isUpdate) {
      _revision = max(_revision, await _toDoAPI.getRevision() ?? -1);
      _toDoAPI.deleteTask(id, _revision);
    }
    _revision++;
    _count -= 1;
  }

  Future setComp(String? id) async {
    int ind = 0;
    for (int i = 0; i < _tasks.length; i++) {
      if (id == _tasks[i].id) {
        _tasks[i].completed = !_tasks[i].completed;
        ind = i;
      }
    }
    final isUpdate =
        await _toDoAPI.refreshTask(id!, _tasks[ind].toJson(), _revision);
    if (isUpdate) {
      _revision = max(_revision, await _toDoAPI.getRevision() ?? -1);
      _toDoAPI.refreshTask(id, _tasks[ind].toJson(), _revision);
    }
    _revision++;
  }

  Future changeTask(Task task, String action, String priority, String period,
      DateTime? deadline) async {
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
    final isUpdate =
        await _toDoAPI.refreshTask(task.id!, _tasks[ind].toJson(), _revision);
    if (isUpdate) {
      _revision = max(_revision, await _toDoAPI.getRevision() ?? -1);
      _toDoAPI.refreshTask(task.id!, _tasks[ind].toJson(), _revision);
    }
    _revision++;
  }
}
