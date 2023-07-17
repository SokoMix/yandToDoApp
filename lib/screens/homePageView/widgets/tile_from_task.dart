import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../app/custom_icons.dart';
import '../../../app/task.dart';
import '../../../controller/controller.dart';
import '../viewData/view_controller.dart';

class TaskTile extends StatefulWidget {
  final Task _task;
  final String? id;

  const TaskTile({Key? key, required this.id, required Task task})
      : _task = task,
        super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _isChecked = false;

  String convertDateTime(DateTime dt) {
    List<String> months = [
      AppLocalizations.of(context)!.jan,
      AppLocalizations.of(context)!.feb,
      AppLocalizations.of(context)!.mar,
      AppLocalizations.of(context)!.apr,
      AppLocalizations.of(context)!.may,
      AppLocalizations.of(context)!.jun,
      AppLocalizations.of(context)!.jul,
      AppLocalizations.of(context)!.aug,
      AppLocalizations.of(context)!.sep,
      AppLocalizations.of(context)!.oct,
      AppLocalizations.of(context)!.nov,
      AppLocalizations.of(context)!.dec
    ];
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    _isChecked = widget._task.completed;
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Dismissible(
          key: UniqueKey(),
          confirmDismiss: (DismissDirection direction) {
            if (direction == DismissDirection.startToEnd) {
              setState(() {
                _isChecked = !_isChecked;
              });
              context.read<Controller>().changeActive(widget.id, _isChecked);
            } else {
              context.read<Controller>().deleteTask(widget._task.id);
            }
            return Future(() => null);
          },
          background: Container(
            alignment: Alignment.centerLeft,
            color: Colors.green,
            child: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 23,
                )),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 23,
                )),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (widget._task.priority == "important")
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 5, right: 10),
                      child: SizedBox(
                          width: 18,
                          height: 18,
                          child: Material(
                              color: Theme.of(context).canvasColor,
                              child: Checkbox(
                                value: _isChecked,
                                checkColor: Colors.white,
                                activeColor: Colors.green,
                                side: MaterialStateBorderSide.resolveWith(
                                    (states) => (!_isChecked)
                                        ? const BorderSide(
                                            width: 2.2,
                                            color:
                                                Color.fromRGBO(252, 33, 37, 1))
                                        : const BorderSide(
                                            width: 2.2,
                                            color: Color.fromRGBO(0, 0, 0, 0))),
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                  if (_isChecked) {
                                    context
                                        .read<Controller>()
                                        .changeActive(widget.id, true);
                                  } else {
                                    context
                                        .read<Controller>()
                                        .changeActive(widget.id, false);
                                  }
                                },
                              ))))
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 5, right: 10),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: _isChecked,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => (!_isChecked)
                                ? BorderSide(
                                    width: 2.2,
                                    color: (Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .color)!)
                                : const BorderSide(
                                    width: 2.2,
                                    color: Color.fromRGBO(0, 0, 0, 0)),
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                            });
                            if (_isChecked) {
                              context
                                  .read<Controller>()
                                  .changeActive(widget.id, true);
                            } else {
                              context
                                  .read<Controller>()
                                  .changeActive(widget.id, false);
                            }
                          },
                        ),
                      ),
                    ),
              (widget._task.priority == AppLocalizations.of(context)!.high)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5, right: 2),
                      child: Icon(
                        CustomIcons.highIcon,
                        color: (!_isChecked)
                            ? const Color(0xFFFF3B30)
                            : Theme.of(context).textTheme.bodySmall!.color,
                        size: 16,
                      ))
                  : const SizedBox.shrink(),
              (widget._task.priority == "low")
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5, right: 2),
                      child: Icon(
                        CustomIcons.lowIcon,
                        color:
                            (Theme.of(context).textTheme.displayMedium!.color)!,
                        size: 16,
                      ))
                  : const SizedBox.shrink(),
              (widget._task.deadline == null)
                  ? Expanded(
                      flex: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          widget._task.action,
                          style: TextStyle(
                            color: (_isChecked)
                                ? Theme.of(context).textTheme.bodySmall!.color
                                : Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 16,
                            height: 20 / 16,
                            decoration: (_isChecked)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    )
                  : Expanded(
                      flex: 50,
                      child: ListTile(
                        dense: true,
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          widget._task.action,
                          style: TextStyle(
                            color: (_isChecked)
                                ? Theme.of(context).textTheme.bodySmall!.color
                                : Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 16,
                            height: 20 / 16,
                            decoration: (_isChecked)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        subtitle: Text(
                          convertDateTime(widget._task.deadline!),
                          style: TextStyle(
                              color: (!_isChecked)
                                  ? const Color(0xFF007AFF)
                                  : Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color,
                              fontSize: 14,
                              height: 20 / 14),
                        ),
                      ),
                    ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: IconButton(
                  padding: const EdgeInsets.only(right: 15, left: 10),
                  constraints: const BoxConstraints(),
                  onPressed: () =>
                      Provider.of<HomePageProvider>(context, listen: false)
                          .onTaskTap(widget._task),
                  icon: Icon(
                    Icons.info_outline,
                    size: 25,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
