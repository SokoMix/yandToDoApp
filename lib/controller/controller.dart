import 'package:flutter/cupertino.dart';
import 'package:yandex_todo/API/todo_api.dart';
import 'package:yandex_todo/API/local_database_api.dart';
import 'package:yandex_todo/DI/container_di.dart';
import '../app/task.dart';
import '../service/model.dart';
import '../app/logger/logger.dart';

class Controller with ChangeNotifier {
  MyLogger logger;
  Model? _model;
  final InstanceCollection _instanceCollection;

  InstanceCollection get instanceCollection => _instanceCollection;

  List<Task> get getTasks => _model!.tasks;

  int get getCount => _model!.count;

  int get completedCnt => _model!.completedCnt;

  Controller(this.logger, this._instanceCollection);

  Future<bool> init() async {
    if (_model == null) {
      _model = Model();
      await _instanceCollection.init();
      _color = _instanceCollection.remoteConfig.getString('color');
      _instanceCollection.remoteConfig.onConfigUpdated.listen((event) async {
        await _instanceCollection.remoteConfig.activate();
        _color = _instanceCollection.remoteConfig.getString('color');
        notifyListeners();
      });
      await _model!.init(LocalDatabase(_instanceCollection.instanceSharPref),
          ToDoAPI(_instanceCollection.instanceDio));
    }
    return true;
  }

  Future deleteTask(String? id) async {
    await _model!.deleteTask(id);
    _model!.saveToLocal();
    _instanceCollection.fbAnalytics.deletedTask(id!);
    notifyListeners();
  }

  Future addTask(String action, String priority, String period, bool completed,
      DateTime? deadline) async {
    await _model!.addTask(action, priority, period, completed, deadline);
    _model!.saveToLocal();
    _instanceCollection.fbAnalytics
        .newTask(action, priority, period, completed, deadline);
    notifyListeners();
  }

  Future changeTask(Task task, String action, String priority, String period,
      DateTime? deadline) async {
    await _model!.changeTask(task, action, priority, period, deadline);
    _model!.saveToLocal();
    _instanceCollection.fbAnalytics
        .changedTask(action, priority, period, deadline);
    notifyListeners();
  }

  Future changeActive(String? ind, bool isAdd) async {
    _model!.setComp(ind);
    (isAdd) ? _model!.addCompleted() : _model!.delCompleted();
    logger.i("$ind\n");
    _model!.saveToLocal();
    _instanceCollection.fbAnalytics.changedActive(ind!, isAdd);
    notifyListeners();
  }

  String _color = "0xFFFF3B30";

  String get color => _color;
}
