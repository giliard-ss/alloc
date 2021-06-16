import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/utils/exception_util.dart';
import 'package:logger/logger.dart';

Logger getLogger() {
  return Logger(printer: LoggerApp());
}

class LoggerApp extends LogPrinter {
  PrettyPrinter p = PrettyPrinter(
      methodCount: 0, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 0, // width of the output
      colors: true, // Colorful log messages
      printEmojis: false, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      );

  @override
  List<String> log(LogEvent event) {
    if (event.level == Level.error) {
      return logError(event);
    }
    LogEvent e = LogEvent(event.level, event.message, event.error, event.stackTrace);
    return p.log(e);
  }

  List<String> logError(LogEvent event) {
    String origem = ExceptionUtil.getMetodoLinha(StackTrace.current, 3);
    String mensagem = "";

    if (event.message is ApplicationException) {
      ApplicationException e = event.message;
      mensagem = "ApplicationException: ${e.message}\n${e.getStackString()}\n$origem";
    } else {
      mensagem =
          "${event.message.toString()}\n ${ExceptionUtil.reduzirStackTrace(StackTrace.current, 15)}\n$origem";
    }

    LogEvent e = LogEvent(event.level, mensagem, event.error, event.stackTrace);
    return p.log(e);
  }
}
