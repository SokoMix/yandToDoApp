import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../controller/controller.dart';
import '../viewData/viewController.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool _isHide = false;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 190,
      collapsedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        title: (context.watch<HomePageProvider>().isCollapsed)
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
                          });
                          context.read<HomePageProvider>().isHide = _isHide;
                        },
                        icon: Icon(
                          (!_isHide) ? Icons.visibility_off : Icons.visibility,
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
                        });
                        context.read<HomePageProvider>().isHide = _isHide;
                      },
                      icon: Icon(
                        (!_isHide) ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).iconTheme.color,
                        size: 21,
                      ),
                    ),
                  ),
                ],
              ),
        titlePadding: (context.watch<HomePageProvider>().isCollapsed)
            ? const EdgeInsets.only(left: 45, bottom: 18)
            : const EdgeInsets.only(left: 20, bottom: 18),
      ),
    );
  }
}
