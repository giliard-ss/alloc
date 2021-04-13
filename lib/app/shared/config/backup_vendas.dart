import 'package:alloc/app/shared/models/evento_venda_renda_variavel.dart';
import 'package:alloc/app/shared/utils/date_util.dart';

class BackupVendas {
  static List<VendaRendaVariavel> getVendas() {
    String carteiraPrincipal = "eyyokB82WciaQB1vf0C4";
    String usuarioId = "7zNUkD8laqglbKVgD1nc1o9zcJ72";
    return [
      VendaRendaVariavel.fiis(null, DateUtil.StringToDate("17/08/2020"), carteiraPrincipal,
          usuarioId, 97.00, 121.61, "HTMX11", 1),
      VendaRendaVariavel.acao(null, DateUtil.StringToDate("25/03/2020"), carteiraPrincipal,
          usuarioId, 497.14, 772.74, "CVCB3", 53,
          custos: 2.49),
      VendaRendaVariavel.acao(null, DateUtil.StringToDate("15/09/2020"), carteiraPrincipal,
          usuarioId, 690.0, 965.10, "BOVA11", 10),
      VendaRendaVariavel.acao(null, DateUtil.StringToDate("15/09/2020"), carteiraPrincipal,
          usuarioId, 788.89, 965.50, "BOVA11", 10),
      VendaRendaVariavel.acao(null, DateUtil.StringToDate("16/09/2020"), carteiraPrincipal,
          usuarioId, 681.0, 965.0, "BOVA11", 10),
      VendaRendaVariavel.etf(null, DateUtil.StringToDate("07/08/2020"), carteiraPrincipal,
          usuarioId, 975.0, 1051.80, "IVVB11", 5),
      VendaRendaVariavel.etf(null, DateUtil.StringToDate("21/08/2020"), carteiraPrincipal,
          usuarioId, 950.0, 1051.80, "IVVB11", 5),
      VendaRendaVariavel.acao(null, DateUtil.StringToDate("02/12/2020"), carteiraPrincipal,
          usuarioId, 66.0, 107.53, "BOVA11", 1),
      VendaRendaVariavel.acao(null, DateUtil.StringToDate("02/12/2020"), carteiraPrincipal,
          usuarioId, 60.95, 107.53, "BOVA11", 1),
      VendaRendaVariavel.acao(null, DateUtil.StringToDate("02/11/2020"), carteiraPrincipal,
          usuarioId, 4032.60, 4422.0, "BOVA11", 44),
      VendaRendaVariavel.fiis(null, DateUtil.StringToDate("01/03/2021"), carteiraPrincipal,
          usuarioId, 970.00, 903.90, "RECT11", 10),
      VendaRendaVariavel.fiis(null, DateUtil.StringToDate("01/03/2021"), carteiraPrincipal,
          usuarioId, 74.50, 90.03, "RECT11", 1),
    ];
  }
}
