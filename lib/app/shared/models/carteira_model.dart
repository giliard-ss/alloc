class CarteiraModel {
  String _id;

  String _idUsuario;
  String _descricao;
  num _totalDeposito;
  bool _autoAlocacao;

  CarteiraModel(this._id, this._idUsuario, this._descricao, this._totalDeposito,
      [this._autoAlocacao = true]);

  CarteiraModel.fromMap(Map map) {
    this._id = map['id'];
    this._descricao = map['descricao'];
    this._idUsuario = map['idUsuario'];
    this._totalDeposito = map['totalDeposito'];
    this._autoAlocacao = map['autoAlocacao'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this._id,
      "descricao": this._descricao,
      "idUsuario": this._idUsuario,
      "totalDeposito": this._totalDeposito,
      "autoAlocacao": this._autoAlocacao
    };
  }

  bool get autoAlocacao => _autoAlocacao;

  set autoAlocacao(bool value) => _autoAlocacao = value;

  String get id => _id;

  set id(String value) => _id = value;

  String get idUsuario => _idUsuario;

  set idUsuario(String value) => _idUsuario = value;

  String get descricao => _descricao;

  set descricao(String value) => _descricao = value;

  num get totalDeposito => _totalDeposito;

  set totalDeposito(num value) => _totalDeposito = value;
}
