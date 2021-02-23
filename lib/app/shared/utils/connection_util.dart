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
}
