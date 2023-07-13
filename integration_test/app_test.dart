import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:yandex_todo/main_dev.dart' as runFile;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Launching app', (WidgetTester tester) async {
    runFile.main();
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 3));
    expect(find.text('Мои дела'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  });

  testWidgets("Adding a task", (WidgetTester tester) async {
    runFile.main();
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(find.bySemanticsLabel("Новое"),
        find.byType(Scaffold), const Offset(0, -100));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel("Новое"));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.bySemanticsLabel("Что надо сделать..."), "Testing task added");
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel("Важность"));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel("!! Высокий").last);
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
        find.byType(Switch), find.byType(Scaffold), const Offset(0, -100));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    final center = tester.getCenter(find.byType(DatePickerDialog));
    await tester.tapAt(Offset(center.dx, center.dy + 20));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel("ОК"));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel("СОХРАНИТЬ"));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.info_outline).last);
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel("Удалить"));
    await tester.pumpAndSettle();
  });
}
