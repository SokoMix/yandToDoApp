import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_todo/API/localDatabaseAPI.dart';
import 'package:yandex_todo/API/toDoAPI.dart';
import 'package:yandex_todo/app/task.dart';
import 'package:yandex_todo/service/model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'unit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ToDoAPI>(), MockSpec<LocalDatabase>()])
@GenerateMocks([Dio, SharedPreferences])
void main() {
  test("testing additive and changing model's functions", () {
    final model = Model();
    model.init(MockLocalDatabase(), MockToDoAPI());
    final List<Task> lst = [
      Task(action: "1", priority: "low", period: "", completed: false),
      Task(
          action: "2",
          priority: "basic",
          period: "20 июля 2023",
          completed: true,
          deadline: DateTime(314)),
      Task(
          action: "3",
          priority: "important",
          period: "26 июня 2023",
          completed: false),
      Task(
          action: "4",
          priority: "basic",
          period: "12 августа 2017",
          completed: true,
          deadline: DateTime(450)),
      Task(
          action: "5",
          priority: "low",
          period: "16 января 2020",
          completed: false),
    ];
    List<String> modelId = [];
    for (int i = 0; i < lst.length; i++) {
      model.addTask(lst[i].action, lst[i].priority, lst[i].period,
          lst[i].completed, lst[i].deadline);
      modelId.add(model.tasks[i].id!);
    }
    for (int i = 0; i < model.tasks.length; i++) {
      model.setComp(modelId[i]);
      lst[i].completed = !lst[i].completed;
    }
    for (int i = 0; i < model.tasks.length; i++) {
      expect(model.tasks[i].action, lst[i].action);
      expect(model.tasks[i].priority, lst[i].priority);
      expect(model.tasks[i].period, lst[i].period);
      expect(model.tasks[i].completed, lst[i].completed);
      expect(model.tasks[i].deadline, lst[i].deadline);
    }
  });

  group("testing ToDoAPI class", () {
    final instance = MockDio();
    final api = ToDoAPI(instance);

    test("testing get revision", () async {
      when(instance.get('/list')).thenAnswer((realInvocation) async =>
          Response(data: {"revision": 123}, requestOptions: RequestOptions()));
      final a = await api.getRevision();
      expect(a, 123);
    });

    test("testing get task", () async {
      final task =
          Task(action: "123", priority: "low", period: "", completed: true);
      when(instance.get('/list'))
          .thenAnswer((realInvocation) async => Response(data: {
                "list": [
                  {
                    "id": task.id,
                    "text": task.action,
                    "importance": task.priority,
                    "done": task.completed,
                    "color": "#FFFFFF",
                    "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
                    "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
                    "last_updated_by": "iphone",
                  }
                ],
                "revision": 45,
              }, requestOptions: RequestOptions()));
      final request = await api.getAllTasks();
      final expTask = Task.fromJson(request![0]);
      expect(task.id, expTask.id);
      expect(task.completed, expTask.completed);
      expect(task.priority, expTask.priority);
      expect(task.deadline, expTask.deadline);
      expect(task.action, expTask.action);
    });
  });
}
