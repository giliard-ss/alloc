class EventoModel {
  String _usuarioId;
  List _values;

  EventoModel(this._usuarioId, this._values);

  EventoModel.fromMap(Map map) {
    this._usuarioId = map["usuarioId"];
    this._values = map["values"];
  }

  Map<String, dynamic> toMap() {
    return {"usuarioId": _usuarioId, "values": _values};
  }
}
