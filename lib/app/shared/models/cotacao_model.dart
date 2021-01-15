class CotacaoModel {
  String _id;
  num _ultimo;
  CotacaoModel(this._id, this._ultimo);

  CotacaoModel.fromMap(Map map) {
    this._id = map['id'];
    this._ultimo = map['ultimo'];
  }

  String get id => _id;

  set id(String value) => _id = value;

  num get ultimo => _ultimo;

  set ultimo(num value) => _ultimo = value;
}
