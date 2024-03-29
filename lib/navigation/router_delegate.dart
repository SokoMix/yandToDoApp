import 'package:flutter/material.dart';
import '../app/task.dart';
import '../screens/homePageView/home_page.dart';
import '../screens/newTaskView/new_task_screen.dart';
import 'navigator_state.dart';

class MyRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  NavigationState? state;

  @override
  NavigationState get currentConfiguration {
    return state ?? NavigationState.root();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: HomePage(onTaskTap: _onTaskTap, onNewTaskTap: _onNewTaskTap),
        ),
        if (state?.isNewTask == true)
          const MaterialPage(
            child: NewTask(task: null),
          ),
        if (state?.isInfoScreen == true)
          MaterialPage(
            child: NewTask(
              task: state?.selectedTaskId,
            ),
          ),
        // if (state?.isUnknown == true)
        //   const MaterialPage(
        //     child: UnknownScreen(),
        //   ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        state = NavigationState.root();

        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    state = configuration;
    notifyListeners();
  }

  void _onTaskTap(Task task) {
    state = NavigationState.task(task);
    notifyListeners();
  }

  void _onNewTaskTap() {
    state = NavigationState.newTask();
    notifyListeners();
  }
}
