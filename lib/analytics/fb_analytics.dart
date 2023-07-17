import 'package:firebase_analytics/firebase_analytics.dart';
import 'fb_analytics_impl.dart';

class FbAnalytics implements FbAnalyticsImpl {
  final FirebaseAnalytics _instance = FirebaseAnalytics.instance;

  @override
  void newTask(String action, String priority, String period, bool completed,
      DateTime? deadline) async {
    _instance.logEvent(name: "new_task", parameters: {
      "priority": priority,
      "deadline": deadline.toString(),
      "action": action
    });
  }

  @override
  void deletedTask(String id) async {
    _instance.logEvent(name: "delete_task", parameters: {"id": id});
  }

  @override
  void changedTask(
      String action, String priority, String period, DateTime? deadline) async {
    _instance.logEvent(name: "change_task", parameters: {
      "priority": priority,
      "deadline": deadline.toString(),
      "action": action
    });
  }

  @override
  void changedActive(String id, bool val) async {
    _instance.logEvent(
        name: "changed_completed", parameters: {"id": id, "completed": val.toString()});
  }
}
