import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/utils/string_util.dart';

class ExceptionUtil {
  static void throwe(dynamic exception, [mensagem]) {
    if (exception is ApplicationException) {
      throw ApplicationException(mensagem != null ? mensagem : exception.message, exception, 2);
    }
    throw exception;
  }

  static String getMetodoLinha(stackCurrent, [linha]) {
    var traceString = stackCurrent.toString().split("\n")[linha == null ? 0 : linha];
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

  static String reduzirStackTrace(stackCurrent, int maximoLinhas) {
    if (StringUtil.isEmpty(stackCurrent.toString())) return "";

    List<String> linhas = stackCurrent.toString().split("\n");

    if (linhas.length > maximoLinhas) linhas = linhas.sublist(0, maximoLinhas);
    String result = "";
    linhas.forEach((e) => result += (e + "\n"));
    return result;
  }
}
