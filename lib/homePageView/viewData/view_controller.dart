import 'package:flutter/material.dart';

import '../../app/task.dart';

class HomePageProvider with ChangeNotifier {
  bool _isHide = false;

  bool get isHide => _isHide;

  set isHide(bool value) {
    _isHide = value;
    notifyListeners();
  }

  bool _showError = true;

  bool get showError => _showError;

  void setShowError() {
    _showError = false;
    notifyListeners();
  }

  bool _isCollapsed = true;

  bool get isCollapsed => _isCollapsed;

  void setIsCollapsed(bool value) {
    _isCollapsed = value;
    notifyListeners();
  }

  late void Function(Task task) _onTaskTap;

  void onTaskTap(Task task) {
    _onTaskTap(task);
  }

  void setOnTaskTap(void Function(Task task) value) {
    _onTaskTap = value;
  }

  late void Function() _onNewTaskTap;

  void Function() get onNewTaskTap => _onNewTaskTap;

  void setOnNewTaskTap(void Function() value) {
    _onNewTaskTap = value;
  }
}
