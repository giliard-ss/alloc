import 'evento.dart';

class EventoVenda extends Evento {
  static final name = "VENDA";
  double _valor;
  double _custos;
  String _tipoAtivo;

  EventoVenda(String id, int dataMilliSeconds, String carteiraId, this._valor, this._custos,
      this._tipoAtivo, String usuarioId)
      : super(id, dataMilliSeconds, carteiraId, name, usuarioId);

  EventoVenda.fromMap(Map map)
      : super(map['id'], map['data'], map['carteiraId'], map['tipoEvento'], map['usuarioId']) {
    this._valor = map['valor'];
    this._custos = map['custos'];
    this._tipoAtivo = map['tipoAtivo'];
  }

  Map<String, dynamic> toMap() {
    Map map = super.toMap();
    map['valor'] = this._valor;
    map['custos'] = this._custos;
    map['tipoAtivo'] = this._tipoAtivo;
    return map;
  }

  double get valor => this._valor;

  set valor(double value) => this._valor = value;

  get custos => this._custos;

  set custos(valor) => this._custos = valor;

  get tipoAtivo => this._tipoAtivo;

  set tipoAtivo(value) => this._tipoAtivo = value;
}
