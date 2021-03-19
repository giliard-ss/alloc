import 'package:alloc/app/shared/models/evento_aplicacao.dart';

class AplicacaoRendaFixa extends EventoAplicacao {
  String _papel;
  double _rentabilidade;
  String _indexador;
  DateTime _vencimento;

  AplicacaoRendaFixa.cdb(
      String id,
      DateTime data,
      String carteiraId,
      String usuarioId,
      double valor,
      double custos,
      List<String> superiores,
      this._papel,
      this._rentabilidade,
      this._indexador,
      this._vencimento)
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "CDB",
            usuarioId);
}
