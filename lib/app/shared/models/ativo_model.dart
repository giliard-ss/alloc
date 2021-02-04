class AtivoModel {
  String _id;
  String _idUsuario;
  String _papel;
  String _idCarteira;
  num _alocacao;
  num _qtd;
  num _preco;
  DateTime _data;

  List _superiores;

  AtivoModel(
      [this._id,
      this._idUsuario,
      this._papel,
      this._idCarteira,
      this._alocacao,
      this._qtd,
      this._preco,
      this._superiores,
      this._data]);

  AtivoModel.fromMap(Map map) {
    this._id = map['id'];
    this._idUsuario = map['idUsuario'];
    this._papel = map['papel'];
    this._idCarteira = map['idCarteira'];
    this._alocacao = map['alocacao'];
    this._qtd = map['qtd'];
    this._preco = map['preco'];
    this._data = DateTime.fromMillisecondsSinceEpoch(map['data']);
    this._superiores = List.generate(map['superiores'].length, (i) {
      return map['superiores'][i];
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'idUsuario': this._idUsuario,
      'papel': this._papel,
      'idCarteira': this._idCarteira,
      'alocacao': this._alocacao,
      'qtd': this._qtd,
      'preco': this._preco,
      'superiores': this._superiores,
      'data': this._data.millisecondsSinceEpoch
    };
  }

  String get id => _id;

  set id(String value) => _id = value;

  String get idCarteira => _idCarteira;

  set idCarteira(String value) => _idCarteira = value;

  String get idUsuario => _idUsuario;

  set idUsuario(String value) => _idUsuario = value;

  String get papel => _papel;

  set papel(String value) => _papel = value;

  double get alocacaoDouble =>
      this._alocacao == null ? 0 : this._alocacao.toDouble();

  set alocacaoDouble(value) => this._alocacao = value;

  num get alocacao => _alocacao;

  set alocacao(num value) => _alocacao = value;

  num get alocacaoPercent => alocacaoDouble * 100;

  set alocacaoPercent(num value) => alocacao = value / 100;

  num get qtd => _qtd;

  set qtd(num value) => _qtd = value;

  num get totalAportado => _preco * qtd;

  List get superiores => _superiores;

  set superiores(List value) => _superiores = value;

  num get preco => _preco;

  set preco(num value) => _preco = value;

  DateTime get data => _data;

  set data(DateTime value) => _data = value;
}
