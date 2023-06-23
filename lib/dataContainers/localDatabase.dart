import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  late SharedPreferences _db;

  LocalDatabase();

  Future<void> init() async {
    _db = await SharedPreferences.getInstance();
  }

  void writeToDB(List<String> tasks) {
    _db.setStringList('tasks', tasks);
  }

  List<String>? getFromDB() {
    return _db.getStringList('tasks');
  }
}
