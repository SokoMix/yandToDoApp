import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:yandex_todo/controller/controller.dart';
import 'package:yandex_todo/homePageView/widgets/taskTile.dart';
import '../app/task.dart';
import '../newTaskView/newTaskScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  bool _isCollapsed = true;
  bool _isHide = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<Controller>().init(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notif) {
              setState(() {
                _isCollapsed = _scrollController.offset <= 110;
              });
              return false;
            },
            child: Scaffold(
              body: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    snap: false,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 190,
                    collapsedHeight: 80,
                    flexibleSpace: FlexibleSpaceBar(
                      title: (_isCollapsed)
                          ? ListTile(
                              title: Text(
                                  AppLocalizations.of(context)!.main_title,
                                  style:
                                      Theme.of(context).textTheme.displayLarge),
                              subtitle: Text(
                                  "${AppLocalizations.of(context)!.completed}${context.watch<Controller>().completedCnt}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                              trailing: Padding(
                                padding: const EdgeInsets.only(top: 36),
                                child: SizedBox(
                                    width: 21,
                                    height: 21,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        setState(() {
                                          _isHide = !_isHide;
                                          context.read<Controller>().isHide =
                                              _isHide;
                                        });
                                      },
                                      icon: Icon(
                                        (!_isHide)
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 21,
                                      ),
                                    )),
                              ),
                            )
                          : Row(
                              children: [
                                Text(AppLocalizations.of(context)!.main_title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isHide = !_isHide;
                                        context.read<Controller>().isHide =
                                            _isHide;
                                      });
                                    },
                                    icon: Icon(
                                      (!_isHide)
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Theme.of(context).iconTheme.color,
                                      size: 21,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      titlePadding: (_isCollapsed)
                          ? const EdgeInsets.only(left: 45, bottom: 18)
                          : const EdgeInsets.only(left: 20, bottom: 18),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, int index) {
                        return Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Material(
                                    elevation: 2.0,
                                    color: Theme.of(context).cardColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: const MainList())),
                            const SizedBox(
                              height: 80,
                            )
                          ],
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewTask(task: null)));
                },
                backgroundColor: const Color(0xFF007AFF),
                child: const Icon(Icons.add),
              ),
            ),
          );
        } else if (!snapshot.hasError) {
          return const CircularProgressIndicator();
        } else {
          return Text(snapshot.error.toString());
        }
      },
    );
  }
}

class MainList extends StatefulWidget {
  const MainList({Key? key}) : super(key: key);

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: generateList(
          context.watch<Controller>().getTasks,
          context.watch<Controller>().getCount,
          AppLocalizations.of(context)!.neww,
          context),
    );
  }
}

List<Widget> generateList(
    List<Task> data, int count, String neww, BuildContext context) {
  List<Widget> retval = [];
  if (context.watch<Controller>().isHide) {
    for (int i = 0; i < count; i++) {
      context
          .watch<Controller>()
          .logger
          .i(("${data[i].id} ${data[i].completed}"));
      if (!data[i].completed) {
        context
            .watch<Controller>()
            .logger
            .i("${data[i].id} ${data[i].completed}");
        retval.add(TaskTile(id: data[i].id, task: data[i]));
      }
    }
  } else {
    for (int i = 0; i < count; i++) {
      context
          .watch<Controller>()
          .logger
          .i("${data[i].id} ${data[i].completed}");
      retval.add(TaskTile(id: data[i].id, task: data[i]));
    }
  }
  retval.add(
    SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewTask(
                        task: null,
                      )));
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Text(
              neww,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
      ),
    ),
  );

  return retval;
}
