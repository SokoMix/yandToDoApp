import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  final SharedPreferences _db;

  LocalDatabase(this._db);

  void writeToDB(List<String> tasks, int revision) {
    _db.setStringList('tasks', tasks);
    _db.setInt('rev', revision);
  }

  (List<String>?, int?) getFromDB() {
    return (_db.getStringList('tasks'), _db.getInt('rev'));
  }
}
