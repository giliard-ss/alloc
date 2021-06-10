import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';

import 'evento.dart';

class EventoAplicacao extends Evento {
  static final tipo = TipoEvento.APLICACAO;
  double _valor;
  double _custos;
  List _superiores;
  String _tipoAtivo;

  EventoAplicacao(String id, int dataMilliSeconds, String carteiraId, this._valor, this._custos,
      this._superiores, this._tipoAtivo, String usuarioId)
      : super(id, dataMilliSeconds, carteiraId, tipo.code, usuarioId);

  EventoAplicacao.fromMap(Map map)
      : super(map['id'], map['data'], map['carteiraId'], map['tipoEvento'], map['usuarioId']) {
    this._valor = map['valor'];
    this._custos = map['custos'];
    this._tipoAtivo = map['tipoAtivo'];
    this._superiores = List.generate(map['superiores'].length, (i) {
      return map['superiores'][i];
    });
  }

  Map<String, dynamic> toMap() {
    Map map = super.toMap();
    map['valor'] = this._valor;
    map['custos'] = this._custos;
    map['tipoAtivo'] = this._tipoAtivo;
    map['superiores'] = this._superiores;
    return map;
  }

  double get valor => this._valor;

  set valor(double value) => this._valor = value;

  get getCustos => this._custos;

  set setCustos(custos) => this._custos = custos;

  get superiores => this._superiores;

  set superiores(value) => this._superiores = value;

  get tipoAtivo => this._tipoAtivo;

  set tipoAtivo(value) => this._tipoAtivo = value;
}
