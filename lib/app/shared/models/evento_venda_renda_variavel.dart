import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/models/evento_venda.dart';

import 'abstract_event.dart';

class VendaRendaVariavel extends EventoVenda implements AbstractEvent {
  String _papel;
  double _qtd;
  double _valorMedioCompra;

  VendaRendaVariavel.fromMap(Map map)
      : super(map['id'], map['data'], map['carteiraId'], map['valor'], map['custos'],
            map['tipoAtivo'], map['usuarioId']) {
    this._papel = map['papel'];
    this._qtd = map['qtd'];
    this._valorMedioCompra = map['valorMedioCompra'];
  }

  @override
  VendaRendaVariavel fromMap(Map map) {
    return VendaRendaVariavel.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    Map map = super.toMap();
    map['papel'] = this._papel;
    map['qtd'] = this._qtd;
    map['valorMedioCompra'] = this._valorMedioCompra;
    return map;
  }

  VendaRendaVariavel.acao(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, "ACAO", usuarioId);

  VendaRendaVariavel.fiis(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, "FIIS", usuarioId);

  VendaRendaVariavel.criptomoeda(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, "CRIPTOMOEDA", usuarioId);

  VendaRendaVariavel.etf(String id, DateTime data, String carteiraId, String usuarioId,
      this._valorMedioCompra, double valor, this._papel, this._qtd,
      {double custos = 0})
      : super(id, data.millisecondsSinceEpoch, carteiraId, valor, custos, "ETF", usuarioId);

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
}
