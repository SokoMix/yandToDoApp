import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_todo/analytics/fb_analytics.dart';

class InstanceCollection {
  final _instanceDio = Dio(BaseOptions(
    baseUrl: 'https://beta.mrdekk.ru/todobackend',
    responseType: ResponseType.json,
    contentType: ContentType.json.toString(),
    headers: {"Authorization": "Bearer eonism"},
  ));

  get instanceDio => _instanceDio;

  late SharedPreferences _instanceSharPref;

  SharedPreferences get instanceSharPref => _instanceSharPref;

  Future<void> init() async {
    _instanceSharPref = await SharedPreferences.getInstance();
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 5),
      minimumFetchInterval: const Duration(seconds: 5),
    ));
  }

  final _fbAnalytics = FbAnalytics();

  get fbAnalytics => _fbAnalytics;

  final _remoteConfig = FirebaseRemoteConfig.instance;

  get remoteConfig => _remoteConfig;
}
