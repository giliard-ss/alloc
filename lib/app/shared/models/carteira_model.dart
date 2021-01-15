class CarteiraModel {
  String _idUsuario;
  String _descricao;
  num _totalDeposito;

  CarteiraModel(this._idUsuario, this._descricao, this._totalDeposito);

  CarteiraModel.fromMap(Map map) {
    this._descricao = map['descricao'];
    this._idUsuario = map['idUsuario'];
    this._totalDeposito = map['totalDeposito'];
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) => _idUsuario = value;

  String get descricao => _descricao;

  set descricao(String value) => _descricao = value;

  double get totalDeposito => _totalDeposito;

  set totalDeposito(double value) => _totalDeposito = value;
}
