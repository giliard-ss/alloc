import 'package:alloc/app/shared/utils/exception_util.dart';

class ApplicationException implements Exception {
  String _message;

  List<String> _stack = [];

  ApplicationException(String message, [dynamic exception, linha]) {
    String origem = ExceptionUtil.getMetodoLinha(
        StackTrace.current, linha == null ? 1 : linha);
    _message = message;

    if (exception != null && exception is ApplicationException) {
      _stack = exception.stack;
    } else if (exception != null) {
      _message = _message + exception.toString();
    }

    _stack.add(origem);
  }

  String getMetodoLinha(dynamic stacktrace) {
    var metodoLinha = stacktrace.toString().split("\n")[0];
    return "$metodoLinha ";
  }

  String getStackString() {
    String result = "";
    this._stack.forEach((e) => {result += "${result == '' ? '' : '\n'}$e"});
    return result;
  }

  @override
  String toString() {
    return _message;
  }

  String get message => _message;
  List get stack => _stack;
}
