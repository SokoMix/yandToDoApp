import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/homePage.dart';
import 'package:provider/provider.dart';
import 'model/controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
