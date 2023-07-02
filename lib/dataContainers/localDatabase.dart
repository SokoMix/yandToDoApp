import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  late SharedPreferences _db;

  LocalDatabase();

  Future<void> init() async {
    _db = await SharedPreferences.getInstance();
  }

  void writeToDB(List<String> tasks, int revision) {
    _db.setStringList('tasks', tasks);
    _db.setInt('rev', revision);
  }

  (List<String>?, int?) getFromDB() {
    return (_db.getStringList('tasks'), _db.getInt('rev'));
  }
}
