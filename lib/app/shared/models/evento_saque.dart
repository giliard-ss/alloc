import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';

import 'evento.dart';

class EventoSaque extends Evento implements AbstractEvent {
  static final tipo = TipoEvento.SAQUE;
  double _valor;

  EventoSaque(String id, int dataMilliSeconds, String carteiraId, String usuarioId, this._valor)
      : super(id, dataMilliSeconds, carteiraId, tipo.code, usuarioId);

  EventoSaque.fromMap(Map map)
      : super(map['id'], map['data'], map['carteiraId'], map['tipoEvento'], map['usuarioId']) {
    this._valor = map['valor'];
  }

  Map<String, dynamic> toMap() {
    Map map = super.toMap();
    map['valor'] = this._valor;
    return map;
  }

  double get valor => this._valor;

  set valor(double value) => this._valor = value;

  @override
  fromMap(Map map) {
    return EventoSaque.fromMap(map);
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
