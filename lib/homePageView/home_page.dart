import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_todo/controller/controller.dart';
import 'package:yandex_todo/homePageView/viewData/view_controller.dart';
import 'package:yandex_todo/homePageView/widgets/error_button.dart';
import 'package:yandex_todo/homePageView/widgets/my_app_bar.dart';
import 'package:yandex_todo/homePageView/widgets/my_task_column.dart';
import '../app/task.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.onTaskTap, required this.onNewTaskTap});

  final void Function(Task task) onTaskTap;
  final void Function() onNewTaskTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<HomePageProvider>().setOnTaskTap(widget.onTaskTap);
    context.read<HomePageProvider>().setOnNewTaskTap(widget.onNewTaskTap);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<Controller>().init(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notif) {
              context
                  .read<HomePageProvider>()
                  .setIsCollapsed(_scrollController.offset <= 110);
              return false;
            },
            child: Scaffold(
              body: CustomScrollView(
                controller: _scrollController,
                slivers: const [
                  MyAppBar(),
                  MyTaskColumn(),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: widget.onNewTaskTap,
                backgroundColor: const Color(0xFF007AFF),
                child: const Icon(Icons.add),
              ),
            ),
          );
        } else if (!snapshot.hasError) {
          return const Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.error is DioException) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notif) {
                context
                    .read<HomePageProvider>()
                    .setIsCollapsed(_scrollController.offset <= 110);
                return false;
              },
              child: Scaffold(
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: const [
                    MyAppBar(),
                    ErrorButton(),
                    MyTaskColumn(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: widget.onNewTaskTap,
                  backgroundColor: const Color(0xFF007AFF),
                  child: const Icon(Icons.add),
                ),
              ),
            );
          }
          return Text(snapshot.error.toString());
        }
      },
    );
  }
}
