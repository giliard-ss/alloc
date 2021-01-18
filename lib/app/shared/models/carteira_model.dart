class CarteiraModel {
  String _id;

  String _idUsuario;
  String _descricao;
  num _totalDeposito;

  CarteiraModel(
      this._id, this._idUsuario, this._descricao, this._totalDeposito);

  CarteiraModel.fromMap(Map map) {
    this._id = map['id'];
    this._descricao = map['descricao'];
    this._idUsuario = map['idUsuario'];
    this._totalDeposito = map['totalDeposito'];
  }
  String get id => _id;

  set id(String value) => _id = value;

  String get idUsuario => _idUsuario;

  set idUsuario(String value) => _idUsuario = value;

  String get descricao => _descricao;

  set descricao(String value) => _descricao = value;

  num get totalDeposito => _totalDeposito;

  set totalDeposito(num value) => _totalDeposito = value;
}
