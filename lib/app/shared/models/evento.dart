import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';

class Evento {
  String _id;
  num _data;
  String _carteiraId;
  String _tipoEvento;
  String _usuarioId;

  Evento(this._id, this._data, this._carteiraId, this._tipoEvento, this._usuarioId);

  Evento.fromMap(Map map) {
    this._id = map['id'];
    this._data = map['data'];
    this._carteiraId = map['carteiraId'];
    this._tipoEvento = map['tipoEvento'];
    this._usuarioId = map['usuarioId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'data': this._data,
      'carteiraId': this._carteiraId,
      'tipoEvento': this._tipoEvento,
      'usuarioId': this._usuarioId,
    };
  }

  String get id => this._id;

  set id(String value) => this._id = value;

  get data => this._data;

  set data(value) => this._data = value;

  get carteiraId => this._carteiraId;

  set carteiraId(value) => this._carteiraId = value;

  get tipoEvento => this._tipoEvento;

  set tipoEvento(value) => this._tipoEvento = value;

  get usuarioId => this._usuarioId;

  set usuarioId(value) => this._usuarioId = value;
}
