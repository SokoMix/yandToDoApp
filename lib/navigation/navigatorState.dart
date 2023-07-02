import '../app/task.dart';

class NavigationState {
  final bool? _unknown;
  final bool? _newTask;

  Task? selectedTaskId;

  bool get isNewTask => _newTask == true;

  bool get isInfoScreen => selectedTaskId != null;

  bool get isHomePage => !isNewTask && !isInfoScreen && !isUnknown;

  bool get isUnknown => _unknown == true;

  NavigationState.root()
      : _newTask = false,
        _unknown = false,
        selectedTaskId = null;

  NavigationState.newTask()
      : _newTask = true,
        _unknown = false,
        selectedTaskId = null;

  NavigationState.task(this.selectedTaskId)
      : _newTask = false,
        _unknown = false;

  NavigationState.unknown()
      : _unknown = true,
        _newTask = false,
        selectedTaskId = null;
}
