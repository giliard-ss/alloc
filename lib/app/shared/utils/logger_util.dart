import 'package:alloc/app/shared/utils/logger_app.dart';

class LoggerUtil {
  static final log = getLogger();

  static void error(dynamic e) {
    log.e(e);
  }

  static void warn(dynamic e) {
    log.w(e);
  }

  static void info(dynamic e) {
    log.i(e);
  }
}
