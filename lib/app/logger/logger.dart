import 'package:logger/logger.dart';

class MyLogger {
  final _logger = Logger();

  void v(String text) {
    _logger.v(text);
  }

  void d(String text) {
    _logger.d(text);
  }

  void i(String text) {
    _logger.i(text);
  }

  void w(String text) {
    _logger.w(text);
  }

  void e(String text) {
    _logger.e(text);
  }

  void wtf(String text) {
    _logger.wtf(text);
  }
}
