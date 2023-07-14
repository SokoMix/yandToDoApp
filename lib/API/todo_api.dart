import 'package:dio/dio.dart';

class ToDoAPI {
  ToDoAPI(this._instance);

  final Dio _instance;

  Future<Map<String, dynamic>?> getTask(String id) async {
    try {
      Response response = await _instance.get('/list/$id');
      return response as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllTasks() async {
    try {
      final response =
          (await _instance.get('/list')).data["list"] as List<dynamic>;
      List<Map<String, dynamic>> lst = [];
      for (int i = 0; i < response.length; i++) {
        lst.add(response[i]);
      }
      return lst;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404 || e.response == null) {
          rethrow;
        }
      }
      return null;
    }
  }

  Future<bool> addTask(Map<String, dynamic> taskMap, int rev) async {
    try {
      await _instance.post(
        '/list',
        options: Options(
          headers: {"X-Last-Known-Revision": rev},
        ),
        data: {"status": 'ok', "element": taskMap},
      );
      return false;
    } catch (e) {
      return (e is DioException && e.response?.statusCode == 400);
    }
  }

  Future<bool> refreshAll(
      List<Map<String, dynamic>> lstWithTasks, int rev) async {
    try {
      await _instance.patch(
        '/list',
        options: Options(
          headers: {"X-Last-Known-Revision": rev},
        ),
        data: {
          "status": "ok",
          "list": lstWithTasks,
        },
      );
      return false;
    } catch (e) {
      return (e is DioException && e.response?.statusCode == 400);
    }
  }

  Future<bool> refreshTask(
      String id, Map<String, dynamic> taskMap, int rev) async {
    try {
      await _instance.put(
        options: Options(
          headers: {"X-Last-Known-Revision": rev},
        ),
        '/list/$id',
        data: {"status": 'ok', "element": taskMap},
      );
      return false;
    } catch (e) {
      return (e is DioException && e.response?.statusCode == 400);
    }
  }

  Future<int?> getRevision() async {
    try {
      Response response = await _instance.get('/list');
      return response.data["revision"];
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteTask(String id, int rev) async {
    try {
      await _instance.delete(
        options: Options(
          headers: {"X-Last-Known-Revision": rev},
        ),
        '/list/$id',
      );
      return false;
    } catch (e) {
      return (e is DioException && e.response?.statusCode == 400);
    }
  }
}
