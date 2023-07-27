import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yandex_todo/DI/container_di.dart';
import 'package:yandex_todo/app/logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:yandex_todo/screens/homePageView/viewData/view_controller.dart';
import 'controller/controller.dart';
import 'navigation/router_delegate.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FlavorConfig(
    name: "dev",
    color: Colors.red,
    location: BannerLocation.bottomStart,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routerDelegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => Controller(MyLogger(), InstanceCollection())),
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
      ],
      child: MaterialApp.router(
          routerDelegate: _routerDelegate,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF7F6F2),
            cardColor: Colors.white,
            iconTheme: const IconThemeData(color: Color(0xFF007AFF)),
            fontFamily: 'Roboto',
            canvasColor: const Color.fromRGBO(254, 216, 214, 1),
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
            canvasColor: const Color.fromRGBO(68, 43, 44, 1),
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
          themeMode: ThemeMode.system),
    );
  }
}
