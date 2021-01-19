class AtivoModel {
  String _idUsuario;
  String _papel;
  String _idCarteira;

  num _alocacao;
  num _qtd;
  num _totalAportado;
  List _superiores;

  AtivoModel(this._idUsuario, this._papel, this._idCarteira, this._alocacao,
      this._qtd, this._totalAportado, this._superiores);

  AtivoModel.fromMap(Map map) {
    this._idUsuario = map['idUsuario'];
    this._papel = map['papel'];
    this._idCarteira = map['idCarteira'];
    this._alocacao = map['alocacao'];
    this._qtd = map['qtd'];
    this._totalAportado = map['totalAportado'];
    this._superiores = List.generate(map['superiores'].length, (i) {
      return map['superiores'][i];
    });
  }
  String get idCarteira => _idCarteira;

  set idCarteira(String value) => _idCarteira = value;

  String get idUsuario => _idUsuario;

  set idUsuario(String value) => _idUsuario = value;

  String get papel => _papel;

  set papel(String value) => _papel = value;

  num get alocacao => _alocacao;

  set alocacao(num value) => _alocacao = value;

  num get qtd => _qtd;

  set qtd(num value) => _qtd = value;

  num get totalAportado => _totalAportado;

  set totalAportado(num value) => _totalAportado = value;

  List get superiores => _superiores;

  set superiores(List value) => _superiores = value;
}
