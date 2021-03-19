import 'package:alloc/app/shared/models/evento_aplicacao.dart';

class ResgateRendaVariavel extends EventoAplicacao {
  String _papel;
  double _quantidade;
  double _valorAplicado;

  ResgateRendaVariavel.acao(String id, DateTime data, String carteiraId, String usuarioId,
      double valor, List<String> superiores, this._papel, this._quantidade, this._valorAplicado,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "ACAO",
            usuarioId);

  ResgateRendaVariavel.fiis(String id, DateTime data, String carteiraId, String usuarioId,
      double valor, List<String> superiores, this._papel, this._quantidade, this._valorAplicado,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "FIIS",
            usuarioId);

  ResgateRendaVariavel.etf(String id, DateTime data, String carteiraId, String usuarioId,
      double valor, List<String> superiores, this._papel, this._quantidade, this._valorAplicado,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "ETF",
            usuarioId);

  ResgateRendaVariavel.criptomoeda(String id, DateTime data, String carteiraId, String usuarioId,
      double valor, List<String> superiores, this._papel, this._quantidade, this._valorAplicado,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "CRIPTOMOEDA",
            usuarioId);
}
