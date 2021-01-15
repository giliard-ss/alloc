import 'package:alloc/app/shared/exceptions/application_exception.dart';

class ExceptionUtil {
  static void throwe(dynamic exception, [mensagem]) {
    if (exception is ApplicationException) {
      throw ApplicationException(
          mensagem != null ? mensagem : exception.message, exception, 2);
    }
    throw exception;
  }

  static String getMetodoLinha(stackCurrent, [linha]) {
    var traceString =
        stackCurrent.toString().split("\n")[linha == null ? 0 : linha];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z]+.dart'));
    var fileInfo = traceString.substring(indexOfFileName);
    var listOfInfos = fileInfo.split(":");
    int lineNumber = int.parse(listOfInfos[1]);

    var metodo = traceString.substring(0, traceString.indexOf("("));
    metodo = metodo.substring(metodo.indexOf(RegExp(r'[A-Za-z]')));

    int indexInicioClasse = traceString.indexOf("(") + 1;
    int indexFinalClasse = traceString.indexOf(")");
    var classe = traceString.substring(indexInicioClasse, indexFinalClasse);
    return "at  $classe ($metodo)";
  }
}
