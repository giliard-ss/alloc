import 'package:alloc/app/shared/dtos/provento_dto.dart';

class ProventoModel {
  String _id;
  String _papel;
  num _data;
  num _valor;

  ProventoModel(this._id, this._papel, this._data, this._valor);

  ProventoModel.fromMap(Map map) {
    this._id = map['id'];
    this._papel = map['papel'];
    this._data = map['data'];
    this._valor = map['valor'];
  }

  Map<String, dynamic> toMap() {
    return {'id': this._id, 'papel': this._papel, 'data': this._data, 'valor': this._valor};
  }

  DateTime get data {
    if (_data == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(_data.toInt());
  }

  String get id => this._id;

  get papel => this._papel;

  get valorDouble => this._valor.toDouble();
}
