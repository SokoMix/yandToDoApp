import 'dart:io';
import 'package:dio/dio.dart';

class ToDoAPI {
  final _instance = Dio(BaseOptions(
    baseUrl: 'https://beta.mrdekk.ru/todobackend',
    responseType: ResponseType.json,
    contentType: ContentType.json.toString(),
    headers: {"Authorization": "Bearer eonism"},
  ));

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
      Response response = await _instance.get('/list');
      return response.data["element"] as List<Map<String, dynamic>>;
    } catch (e) {
      return null;
    }
  }

  void addTask(Map<String, dynamic> taskMap) async {
    await _instance.post(
      '/list',
      options: Options(
        headers: {"X-Last-Known-Revision": 0},
      ),
      data: taskMap,
    );
  }

  void refreshAll(List<Map<String, dynamic>> lstWithTasks) async {
    await _instance.patch(
      '/list',
      options: Options(
        headers: {"X-Last-Known-Revision": 0},
      ),
      data: {
        "status": "ok",
        "list": lstWithTasks,
      },
    );
  }

  void refreshTask(String id, Map<String, dynamic> taskMap) async {
    await _instance.post(
      '/list/$id',
      data: taskMap,
    );
  }

  void deleteTask(String id) async {
    await _instance.delete('/list/$id');
  }
}
