import 'package:flutter/cupertino.dart';
import '../app/task.dart';
import '../dataContainers/model.dart';
import '../app/logger/logger.dart';

class Controller with ChangeNotifier {
  final MyLogger logger = MyLogger(); // через D/I
  Model? _model = null;

  List<Task> get getTasks => _model!.tasks;

  int get getCount => _model!.count;

  int get completedCnt => _model!.completedCnt;

  bool get isHide => _model!.isHide;

  Controller();

  set isHide(bool value) {
    _model!.isHide = value;
    notifyListeners();
  }

  Future<bool> init() async {
    if (_model == null) {
      _model = Model();
      await _model!.init();
      return true;
    } else
      return true;
  }

  void deleteTask(String? id) {
      _model!.deleteTask(id);
      _model!.saveToLocal();
      notifyListeners();
  }

  void addTask(String action, String priority, String period, bool completed,
      DateTime? deadline) {
    _model!.addTask(action, priority, period, completed, deadline);
    _model!.saveToLocal();
    notifyListeners();
  }

  void changeTask(Task task, String action, String priority, String period,
      DateTime? deadline) {
    _model!.changeTask(task, action, priority, period, deadline);
    _model!.saveToLocal();
    notifyListeners();
  }

  void changeActive(String? ind, bool isAdd) {
    _model!.setComp(ind);
    (isAdd) ? _model!.addCompleted() : _model!.delCompleted();
    logger.i("$ind\n");
    _model!.saveToLocal();
    notifyListeners();
  }
}
