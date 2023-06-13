import 'package:flutter/cupertino.dart';
import 'task.dart';
import 'model.dart';

class Controller with ChangeNotifier {
  Model model = Model();
  Controller();
  List<Task> get getTasks => model.tasks;
  int get getCount => model.count;
  int get completedCnt => model.completedCnt;
  bool get isHide => model.isHide;
  set isHide(bool value) {
    model.isHide = value;
    notifyListeners();
  }

  void deleteTask(int id) {
    model.deleteTask(id);
    notifyListeners();
  }

  void addTask(String action, String priority, String period, bool completed) {
    model.addTask(action, priority, period, completed);
    notifyListeners();
  }

  void changeTask(Task task, String action, String priority, String period) {
    model.changeTask(task, action, priority, period);
    notifyListeners();
  }

  void changeActive(int ind, bool isAdd) {
    model.setComp(ind);
    (isAdd) ? model.addCompleted() : model.delCompleted();
    debugPrint("$ind\n");
    notifyListeners();
  }
}
