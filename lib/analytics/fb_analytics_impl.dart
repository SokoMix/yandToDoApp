abstract class FbAnalyticsImpl {
  void newTask(String action, String priority, String period, bool completed,
      DateTime? deadline);
  void deletedTask(String id);
  void changedTask(
      String action, String priority, String period, DateTime? deadline);
  void changedActive(String id, bool val);
}
