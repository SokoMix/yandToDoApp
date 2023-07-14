import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewData/view_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorButton extends StatelessWidget {
  const ErrorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int index) {
          return (context.watch<HomePageProvider>().showError)
              ? SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                              AppLocalizations.of(context)!.connection_error)),
                      const Spacer(),
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<HomePageProvider>().setShowError();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).iconTheme.color),
                            child: const Text("OK"),
                          )),
                    ],
                  ),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                );
        },
        childCount: 1,
      ),
    );
  }
}
