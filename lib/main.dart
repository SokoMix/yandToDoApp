import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'newTaskScreen.dart';
import 'package:provider/provider.dart';
import 'taskTile.dart';
import 'controller.dart';
import 'task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return ChangeNotifierProvider<Controller>(
        create: (context) => Controller(),
        child: MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF7F6F2),
            cardColor: Colors.white,
            iconTheme: const IconThemeData(color: Color(0xFF007AFF)),
            fontFamily: 'Roboto',
            disabledColor: const Color.fromRGBO(0, 0, 0, 0.15),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  height: 38 / 32,
                  fontWeight: FontWeight.w500),
              displayMedium: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  fontSize: 16,
                  height: 20 / 16),
              bodyMedium:
                  TextStyle(color: Colors.black, fontSize: 16, height: 20 / 16),
              bodySmall: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  fontSize: 14,
                  height: 20 / 14),
              labelSmall: TextStyle(
                  color: Color(0xFFFF3B30),
                  fontSize: 16,
                  height: 20 / 16,
                  letterSpacing: 0),
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFF161618),
            iconTheme: const IconThemeData(color: Color(0xFF007AFF)),
            cardColor: const Color(0xFF252528),
            disabledColor: const Color.fromRGBO(255, 255, 255, 0.15),
            fontFamily: 'Roboto',
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  height: 38 / 32,
                  fontWeight: FontWeight.w500),
              displayMedium: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.4),
                  fontSize: 16,
                  height: 20 / 16),
              bodyMedium:
                  TextStyle(color: Colors.white, fontSize: 16, height: 20 / 16),
              bodySmall: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.4),
                  fontSize: 14,
                  height: 20 / 14),
              labelSmall: TextStyle(
                  color: Color(0xFFFF3B30),
                  fontSize: 16,
                  height: 20 / 16,
                  letterSpacing: 0),
            ),
          ),
          themeMode: ThemeMode.system,
          home: const HomePage(),
        ));
  }
}

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
    return NotificationListener<ScrollNotification>(
      onNotification: (notif) {
        setState(() {
          _isCollapsed = _scrollController.offset <= 110;
          debugPrint("$_isCollapsed");
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
                        title: Text(AppLocalizations.of(context)!.main_title,
                            style: Theme.of(context).textTheme.displayLarge),
                        subtitle: Text(
                            "${AppLocalizations.of(context)!.completed}${context.watch<Controller>().completedCnt}",
                            style: Theme.of(context).textTheme.displayMedium),
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
                                    context.read<Controller>().isHide = _isHide;
                                  });
                                },
                                icon: Icon(
                                  (!_isHide)
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 21,
                                ),
                              )),
                        ),
                      )
                    : Row(
                        children: [
                          Text(AppLocalizations.of(context)!.main_title,
                              style: Theme.of(context).textTheme.displayLarge),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isHide = !_isHide;
                                  context.read<Controller>().isHide = _isHide;
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Material(
                              elevation: 2.0,
                              color: Theme.of(context).cardColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
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
      debugPrint("${data[i].id} ${data[i].completed}");
      if (!data[i].completed) {
        debugPrint("${data[i].id} ${data[i].completed}");
        retval.add(TaskTile(id: data[i].id, task: data[i]));
      }
    }
  } else {
    for (int i = 0; i < count; i++) {
      debugPrint("${data[i].id} ${data[i].completed}");
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