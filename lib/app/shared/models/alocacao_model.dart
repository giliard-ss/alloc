class AlocacaoModel {
  String _id;
  String _idUsuario;

  String _descricao;
  num _alocacao;
  String _idCarteira;
  String _idSuperior;
  bool _autoAlocacao;

  AlocacaoModel(
      [this._id,
      this._idUsuario,
      this._descricao,
      this._alocacao,
      this._idCarteira,
      this._idSuperior,
      this._autoAlocacao = true]);

  AlocacaoModel.fromMap(Map map) {
    this._id = map['id'];
    this.idUsuario = map['idUsuario'];
    this._descricao = map['descricao'];
    this._alocacao = map['alocacao'];
    this._idCarteira = map['idCarteira'];
    this._idSuperior = map['idSuperior'];
    this._autoAlocacao = map['autoAlocacao'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'idUsuario': _idUsuario,
      'descricao': _descricao,
      'alocacao': _alocacao,
      'idCarteira': _idCarteira,
      'idSuperior': _idSuperior,
      'autoAlocacao': _autoAlocacao
    };
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) => _idUsuario = value;

  double get alocacaoDouble =>
      this._alocacao == null ? 0 : this._alocacao.toDouble();

  set alocacaoDouble(value) => this._alocacao = value;

  bool get autoAlocacao => _autoAlocacao;

  set autoAlocacao(bool value) => _autoAlocacao = value;

  String get id => _id;

  set id(String value) => _id = value;

  String get descricao => _descricao;

  set descricao(String value) => _descricao = value;

  num get alocacao => _alocacao;

  num get alocacaoPercent => (alocacaoDouble * 1000) / 10;

  String get alocacaoPercentString {
    String aloc = alocacaoPercent.toString();
    if (aloc.split('.')[1] == '0') {
      return aloc.split('.')[0];
    }
    return aloc;
  }

  set alocacaoPercent(num value) => alocacao = value / 100;

  set alocacao(num value) => _alocacao = value;

  String get idCarteira => _idCarteira;

  set idCarteira(String value) => _idCarteira = value;

  String get idSuperior => _idSuperior;

  set idSuperior(String value) => _idSuperior = value;
}
