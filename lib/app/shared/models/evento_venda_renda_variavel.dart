import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/models/evento_venda.dart';

import 'abstract_event.dart';

class VendaRendaVariavelEvent extends EventoVenda implements AbstractEvent {
  String _papel;
  double _qtd;
  double _valorMedioCompra;

  VendaRendaVariavelEvent.fromMap(Map map)
      : super(map['id'], map['data'], map['carteiraId'], map['valor'], map['custos'],
            map['superiores'], map['tipoAtivo'], map['usuarioId']) {
    this._papel = map['papel'];
    this._qtd = map['qtd'];
    this._valorMedioCompra = map['valorMedioCompra'];
  }

  @override
  VendaRendaVariavelEvent fromMap(Map map) {
    return VendaRendaVariavelEvent.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    Map map = super.toMap();
    map['papel'] = this._papel;
    map['qtd'] = this._qtd;
    map['valorMedioCompra'] = this._valorMedioCompra;
    return map;
  }

  VendaRendaVariavelEvent(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, List<String> superiores, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores,
            TipoAtivo.byPapel(_papel).code, usuarioId);

  VendaRendaVariavelEvent.acao(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, List<String> superiores, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "ACAO",
            usuarioId);

  VendaRendaVariavelEvent.fiis(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, List<String> superiores, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "FIIS",
            usuarioId);

  VendaRendaVariavelEvent.criptomoeda(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, List<String> superiores, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "CRIPTOMOEDA",
            usuarioId);

  VendaRendaVariavelEvent.etf(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, List<String> superiores, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, superiores, "ETF",
            usuarioId);

  String get papel => this._papel;

  set papel(String value) => this._papel = value;

  get qtd => this._qtd;

  String get qtdString {
    if (tipoAtivo == TipoAtivo.CRIPTOMOEDA) {
      return _qtd.toString();
    }
    return _qtd.ceil().toString();
  }

  set qtd(value) => this._qtd = value;

  double get precoUnitario => valor / _qtd;

  double get lucro => super.valor - _valorMedioCompra - super.custos;

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

  @override
  double getValor() {
    return super.valor;
  }
}
