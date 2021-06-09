import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

import 'evento.dart';

class EventoProvento extends Evento implements AbstractEvent {
  static final name = "PROVENTO";
  double _valor;
  double _qtd;
  String _papel;
  String _tipoAtivo;
  String _idProvento;

  EventoProvento(String id, int dataMilliSeconds, String carteiraId, String usuarioId, this._valor,
      this._qtd, this._papel,
      [this._idProvento])
      : super(id, dataMilliSeconds, carteiraId, name, usuarioId) {
    this._tipoAtivo = TipoAtivo.byPapel(this._papel).toString();
  }

  EventoProvento.fromMap(Map map)
      : super(map['id'], map['data'], map['carteiraId'], map['tipoEvento'], map['usuarioId']) {
    this._valor = map['valor'];
    this._qtd = map['qtd'];
    this._papel = map['papel'];
    this._tipoAtivo = map['tipoAtivo'];
    this._idProvento = map['idProvento'];
  }

  Map<String, dynamic> toMap() {
    Map map = super.toMap();
    map['valor'] = this._valor;
    map['qtd'] = this._qtd;
    map['papel'] = this._papel;
    map['tipoAtivo'] = this._tipoAtivo;
    map['idProvento'] = this._idProvento;
    return map;
  }

  double get precoUnitario => GeralUtil.limitaCasasDecimais(this._valor / this._qtd);

  double get valor => this._valor;

  double get qtd => this._qtd;

  String get qtdString => _qtd.ceil().toString();

  set valor(double value) => this._valor = value;

  String get tipoAtivo => this._tipoAtivo;

  String get papel => this._papel;

  String get idProvento => this._idProvento;

  set idProvento(String value) => this._idProvento = value;

  @override
  fromMap(Map map) {
    return EventoProvento.fromMap(map);
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
  void setId(String id) {
    super.id = id;
  }

  @override
  double getValor() {
    return _valor;
  }
}
