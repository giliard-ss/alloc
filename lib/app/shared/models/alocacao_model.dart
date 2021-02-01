class AlocacaoModel {
  String _id;
  String _descricao;
  num _alocacao;
  String _idCarteira;
  String _idSuperior;

  AlocacaoModel(
      [this._id,
      this._descricao,
      this._alocacao,
      this._idCarteira,
      this._idSuperior]);

  AlocacaoModel.fromMap(Map map) {
    this._id = map['id'];
    this._descricao = map['descricao'];
    this._alocacao = map['alocacao'];
    this._idCarteira = map['idCarteira'];
    this._idSuperior = map['idSuperior'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'descricao': _descricao,
      'alocacao': _alocacao,
      'idCarteira': _idCarteira,
      'idSuperior': _idSuperior
    };
  }

  double get alocacaoDouble =>
      this._alocacao == null ? 0 : this._alocacao.toDouble();

  String get id => _id;

  set id(String value) => _id = value;

  String get descricao => _descricao;

  set descricao(String value) => _descricao = value;

  num get alocacao => _alocacao;

  set alocacao(num value) => _alocacao = value;

  String get idCarteira => _idCarteira;

  set idCarteira(String value) => _idCarteira = value;

  String get idSuperior => _idSuperior;

  set idSuperior(String value) => _idSuperior = value;
}
