import 'dart:io';
import 'package:dio/dio.dart';

class ToDoAPI {
  ToDoAPI();

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
      final response = (await _instance.get('/list')).data["list"] as List<dynamic>;
      List<Map<String, dynamic>> lst = [];
      for (int i = 0; i < response.length; i++) {
        lst.add(response[i]);
      }
      return lst;
    } catch (e) {
      return null;
    }
  }

  void addTask(Map<String, dynamic> taskMap, int rev) async {
    await _instance.post(
      '/list',
      options: Options(
        headers: {"X-Last-Known-Revision": rev},
      ),
      data: { "status": 'ok',
        "element" : taskMap},
    );
  }

  void refreshAll(List<Map<String, dynamic>> lstWithTasks, int rev) async {
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
  }

  void refreshTask(String id, Map<String, dynamic> taskMap, int rev) async {
    await _instance.put(
      options: Options(
        headers: {"X-Last-Known-Revision": rev},
      ),
      '/list/$id',
      data: { "status": 'ok',
        "element" : taskMap},
    );
  }

  Future<int?> getRevision() async
  {
      Response response = await _instance.get('/list');
      return response.data["revision"];
  }

  void deleteTask(String id, int rev) async {
    await _instance.delete(
      options: Options(
        headers: {"X-Last-Known-Revision": rev},
      ),
        '/list/$id',
    );
  }
}