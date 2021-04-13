import 'package:alloc/app/shared/models/evento_deposito.dart';
import 'package:alloc/app/shared/utils/date_util.dart';

class BackupDepositos {
  static List<EventoDeposito> getAllDepositos() {
    String carteiraPrincipal = "eyyokB82WciaQB1vf0C4";
    String usuarioId = "7zNUkD8laqglbKVgD1nc1o9zcJ72";

    return [
      EventoDeposito(null, DateUtil.StringToDate("01/03/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 11908.00),
      EventoDeposito(null, DateUtil.StringToDate("14/04/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2365.00),
      EventoDeposito(null, DateUtil.StringToDate("07/05/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("01/06/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("01/07/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("01/08/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("01/09/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("01/10/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("01/11/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("01/12/2020").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("07/01/2021").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("07/02/2021").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 2300.00),
      EventoDeposito(null, DateUtil.StringToDate("21/02/2021").millisecondsSinceEpoch,
          carteiraPrincipal, usuarioId, 33000.00),
    ];
  }
}
