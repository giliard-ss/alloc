import 'package:alloc/app/shared/models/evento_aplicacao.dart';

import 'abstract_event.dart';

class AplicacaoRendaVariavel extends EventoAplicacao implements AbstractEvent {
  String _papel;
  double _qtd;

  AplicacaoRendaVariavel.fromMap(Map map)
      : super(map['id'], map['data'], map['carteiraId'], map['valor'], map['custos'],
            map['superiores'], map['tipoAtivo'], map['usuarioId']) {
    this._papel = map['papel'];
    this._qtd = map['qtd'];
  }

  @override
  AplicacaoRendaVariavel fromMap(Map map) {
    return AplicacaoRendaVariavel.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    Map map = super.toMap();
    map['papel'] = this._papel;
    map['qtd'] = this._qtd;
    return map;
  }

  AplicacaoRendaVariavel.acao(String id, DateTime data, String carteiraId, String usuarioId,
      double valor, List<String> superiores, this._papel, this._qtd, {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "ACAO",
            usuarioId);

  AplicacaoRendaVariavel.fiis(String id, DateTime data, String carteiraId, String usuarioId,
      double valor, List<String> superiores, this._papel, this._qtd, {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "FIIS",
            usuarioId);

  AplicacaoRendaVariavel.criptomoeda(String id, DateTime data, String carteiraId, String usuarioId,
      double valor, List<String> superiores, this._papel, this._qtd, {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "CRIPTOMOEDA",
            usuarioId);

  AplicacaoRendaVariavel.etf(String id, DateTime data, String carteiraId, String usuarioId,
      double valor, List<String> superiores, this._papel, this._qtd, {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "ETF",
            usuarioId);

  String get papel => this._papel;

  set papel(String value) => this._papel = value;

  get qtd => this._qtd;

  set qtd(value) => this._qtd = value;

  @override
  void setId(String id) {
    super.id = id;
  }

  @override
  DateTime getData() {
    return DateTime.fromMillisecondsSinceEpoch(super.data);
  }

  @override
  String getId() {
    return super.id;
  }

  @override
  String getTipoEvento() {
    return super.tipoEvento;
  }
}
