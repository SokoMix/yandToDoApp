import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_todo/homePageView/widgets/tile_from_task.dart';
import '../../app/task.dart';
import '../../controller/controller.dart';
import '../viewData/view_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTaskColumn extends StatelessWidget {
  const MyTaskColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int index) {
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Material(
                      elevation: 2.0,
                      color: Theme.of(context).cardColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: const MainList())),
              const SizedBox(
                height: 80,
              )
            ],
          );
        },
        childCount: 1,
      ),
    );
  }
}

class MainList extends StatelessWidget {
  const MainList({Key? key}) : super(key: key);

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
  if (context.watch<HomePageProvider>().isHide) {
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
        onPressed: context.watch<HomePageProvider>().onNewTaskTap,
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
