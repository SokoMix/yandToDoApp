import 'package:flutter/cupertino.dart';
import 'package:yandex_todo/API/toDoAPI.dart';
import 'package:yandex_todo/API/localDatabaseAPI.dart';
import 'package:yandex_todo/DI/containerDI.dart';
import '../app/task.dart';
import '../service/model.dart';
import '../app/logger/logger.dart';

class Controller with ChangeNotifier {
  MyLogger logger;
  Model? _model;
  final InstanceCollection _instanceCollection;

  List<Task> get getTasks => _model!.tasks;

  int get getCount => _model!.count;

  int get completedCnt => _model!.completedCnt;

  Controller(this.logger, this._instanceCollection);

  Future<bool> init() async {
    if (_model == null) {
      _model = Model();
      await _instanceCollection.init();
      await _model!.init(LocalDatabase(_instanceCollection.instanceSharPref),
          ToDoAPI(_instanceCollection.instanceDio));
    }
    return true;
  }

  Future deleteTask(String? id) async {
    await _model!.deleteTask(id);
    _model!.saveToLocal();
    notifyListeners();
  }

  Future addTask(String action, String priority, String period, bool completed,
      DateTime? deadline) async {
    await _model!.addTask(action, priority, period, completed, deadline);
    _model!.saveToLocal();
    notifyListeners();
  }

  Future changeTask(Task task, String action, String priority, String period,
      DateTime? deadline) async {
    await _model!.changeTask(task, action, priority, period, deadline);
    _model!.saveToLocal();
    notifyListeners();
  }

  Future changeActive(String? ind, bool isAdd) async {
    _model!.setComp(ind);
    (isAdd) ? _model!.addCompleted() : _model!.delCompleted();
    logger.i("$ind\n");
    _model!.saveToLocal();
    notifyListeners();
  }
}
