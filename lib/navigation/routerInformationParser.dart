import 'package:flutter/material.dart';
import 'navigatorState.dart';
import 'routes.dart';

class MyRouteInformationParser extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    final location = routeInformation.location;
    final routes = Routes();
    if (location == null) {
      return NavigationState.unknown();
    }

    final uri = Uri.parse(location);

    if (uri.pathSegments.isEmpty) {
      return NavigationState.root();
    }

    if (uri.pathSegments.length == 2) {
      final itemId = uri.pathSegments[1];

      // if (uri.pathSegments[0] == Routes.task) {
      //   return NavigationState.task(itemId); // как тут понять существует ли таск???
      // }

      return NavigationState.unknown();
    }

    if (uri.pathSegments.length == 1) {
      final path = uri.pathSegments[0];
      if (path == routes.newTask) {
        return NavigationState.newTask();
      }

      return NavigationState.root();
    }

    return NavigationState.root();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    final routes = Routes();
    if (configuration.isNewTask) {
      return const RouteInformation(location: '/');
    }

    if (configuration.isInfoScreen) {
      return RouteInformation(
          location: '/${routes.task}/${configuration.selectedTaskId}');
    }

    if (configuration.isUnknown) {
      return null;
    }

    return const RouteInformation(location: '/');
  }
}
