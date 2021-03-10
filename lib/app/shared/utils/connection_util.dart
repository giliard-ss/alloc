import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/utils/exception_util.dart';
import 'package:connectivity/connectivity.dart';

class ConnectionUtil {
  static Future<bool> isOnline() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      ExceptionUtil.throwe(e, "Falha ao verificar conectividade");
    }
  }

  static Future<bool> isOffline() async {
    return !await isOnline();
  }

  static Future<void> checkConnection() async {
    bool online = await isOnline();
    if (!online) throw ApplicationException("Falha de conexão com a internet!");
  }
}
