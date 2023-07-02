import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  }
}
