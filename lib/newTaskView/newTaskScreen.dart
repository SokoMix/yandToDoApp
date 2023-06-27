import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../app/task.dart';
import '../controller/controller.dart';

class NewTask extends StatefulWidget {
  final Task? _task;

  const NewTask({Key? key, required Task? task})
      : _task = task,
        super(key: key);

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  late TextEditingController _inputCtrl;
  bool _isSwitched = false;
  final _scrollCtrl = ScrollController();
  late TextEditingController _priorityCtrl;
  bool _isScrolled = true;
  bool _isUploadedDateTime = false;
  bool _emptyText = false;
  bool _isButtonDisabled = true;
  DateTime? _selectedDate;
  String _toDate = "";
  String _priority = "";

  @override
  dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final tmp = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040));
    setState(() {
      _selectedDate = tmp;
      if (tmp != null) {
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
        _toDate = "${tmp.day} ${months[tmp.month - 1]} ${tmp.year}";
      } else {
        _isSwitched = false;
      }
    });
    return _selectedDate;
  }

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

  void _setDate(DateTime? date) {
    if (date != null) {
      setState(() {
        _isSwitched = true;
        _toDate = convertDateTime(date);
        _selectedDate = date;
      });
    }
  }

  @override
  void initState() {
    if (widget._task != null) {
      setState(() {
        _isButtonDisabled = false;
      });
    }
    _inputCtrl = TextEditingController(text: widget._task?.action ?? "");
    _priorityCtrl = TextEditingController(text: widget._task?.priority ?? "");
    _priority = widget._task?.priority ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_priorityCtrl.text == "") {
      _priorityCtrl.text = AppLocalizations.of(context)!.none;
    }
    if (!_isUploadedDateTime) {
      _setDate(widget._task?.deadline);
      _isUploadedDateTime = true;
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notif) {
        setState(() {
          _isScrolled = _scrollCtrl.offset <= 0;
          debugPrint("$_isScrolled");
        });
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: (_isScrolled) ? 0 : 6,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _emptyText = _inputCtrl.text == "";
                  });
                  if (!_emptyText) {
                    if (widget._task == null) {
                      context.read<Controller>().addTask(_inputCtrl.text,
                          _priority, _toDate, false, _selectedDate);
                      Navigator.pop(context);
                    } else {
                      context.read<Controller>().changeTask(widget._task!,
                          _inputCtrl.text, _priority, _toDate, _selectedDate);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: const TextStyle(
                      color: Color(0xFF007AFF), fontSize: 14, height: 24 / 14),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollCtrl,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Material(
                    elevation: 2.0,
                    color: Theme.of(context).cardColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextField(
                        cursorColor: const Color(0xFF007AFF),
                        controller: _inputCtrl,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            errorText: (_emptyText)
                                ? AppLocalizations.of(context)!.empty_case
                                : null,
                            errorStyle:
                                const TextStyle(color: Color(0xFF007AFF)),
                            hintText:
                                AppLocalizations.of(context)!.what_need_to_do,
                            hintStyle:
                                Theme.of(context).textTheme.displayMedium),
                        minLines: 4,
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 21),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownMenu<String>(
                        controller: _priorityCtrl,
                        label: Text(AppLocalizations.of(context)!.priority),
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        initialSelection: _priority,
                        trailingIcon: const Icon(
                          Icons.add,
                          size: 0,
                        ),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                              value: AppLocalizations.of(context)!.none,
                              label: AppLocalizations.of(context)!.none),
                          DropdownMenuEntry(
                              value: AppLocalizations.of(context)!.low,
                              label: AppLocalizations.of(context)!.low),
                          DropdownMenuEntry(
                              value: AppLocalizations.of(context)!.high,
                              label: AppLocalizations.of(context)!.high,
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red)),
                        ],
                        inputDecorationTheme: InputDecorationTheme(
                          filled: false,
                          outlineBorder: BorderSide.none,
                          border: InputBorder.none,
                          constraints: const BoxConstraints(maxHeight: 30),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 21.5),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0.0),
                        ),
                        onSelected: (String? text) {
                          setState(() {
                            _priority = text!;
                          });
                        },
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Divider(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    thickness: 0.8,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: SizedBox(
                      height: 60,
                      child: (_isSwitched)
                          ? ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              trailing: Switch(
                                onChanged: (val) {
                                  setState(() {
                                    _isSwitched = !_isSwitched;
                                    if (_isSwitched) {
                                      pickDate(context);
                                    } else {
                                      _toDate = "";
                                      _selectedDate = null;
                                    }
                                  });
                                },
                                value: _isSwitched,
                                activeColor: const Color(0xFF007AFF),
                                inactiveThumbColor:
                                    Theme.of(context).disabledColor,
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.do_before,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                _toDate,
                                style: const TextStyle(
                                    color: Color(0xFF007AFF),
                                    fontSize: 14,
                                    height: 20 / 14),
                              ),
                            )
                          : Row(
                              children: [
                                Text(AppLocalizations.of(context)!.do_before,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                const Spacer(),
                                Switch(
                                  value: _isSwitched,
                                  onChanged: (val) {
                                    setState(() {
                                      _isSwitched = !_isSwitched;
                                      if (_isSwitched) {
                                        pickDate(context);
                                      } else {
                                        _toDate = "";
                                        _selectedDate = null;
                                      }
                                    });
                                  },
                                  activeColor: const Color(0xFF007AFF),
                                  inactiveThumbColor:
                                      Theme.of(context).cardColor,
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Divider(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    thickness: 0.8,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: TextButton(
                          onPressed: () {
                            if (_isButtonDisabled) return;
                            context
                                .read<Controller>()
                                .deleteTask(widget._task!.id);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: Icon(
                                  Icons.delete,
                                  color: (_isButtonDisabled)
                                      ? Theme.of(context).disabledColor
                                      : const Color(0xFFFF3B30),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.delete,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: (_isButtonDisabled)
                                            ? Theme.of(context).disabledColor
                                            : const Color(0xFFFF3B30)),
                              ),
                            ],
                          ),
                        )),
                    const Spacer()
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
