import 'package:alloc/app/shared/utils/geral_util.dart';

class AtivoModel {
  String _id;
  String _idUsuario;
  String _papel;
  String _idCarteira;
  num _alocacao;
  num _qtd;
  num _precoMedio;
  DateTime _dataRecente;
  String _tipo;
  num _precoRecente;

  List _superiores;

  AtivoModel(
      [this._id,
      this._idUsuario,
      this._papel,
      this._idCarteira,
      this._alocacao,
      this._qtd,
      this._precoMedio,
      this._superiores,
      this._dataRecente,
      this._tipo,
      this._precoRecente]) {
    if (this.dataRecente == null) {
      this.dataRecente = DateTime.now();
    }

    if (this.superiores == null) {
      this.superiores = [];
    }
  }

  AtivoModel.fromMap(Map map) {
    this._id = map['id'];
    this._idUsuario = map['idUsuario'];
    this._papel = map['papel'];
    this._idCarteira = map['idCarteira'];
    this._alocacao = map['alocacao'];
    this._qtd = map['qtd'];
    this._precoMedio = map['precoMedio'];
    this._dataRecente = DateTime.fromMillisecondsSinceEpoch(map['dataRecente']);
    this._tipo = map['tipo'];
    this._precoRecente = map['precoRecente'];
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
      'precoMedio': this._precoMedio,
      'tipo': this._tipo,
      'precoRecente': this._precoRecente,
      'superiores': this._superiores,
      'dataRecente': this._dataRecente.millisecondsSinceEpoch
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

  String get alocacaoPercentString {
    String aloc = GeralUtil.limitaCasasDecimais(alocacaoPercent.toDouble(),
            casasDecimais: 1)
        .toString();
    if (aloc.split('.')[1] == '0') {
      return aloc.split('.')[0];
    }
    return aloc;
  }

  set alocacaoPercent(num value) => alocacao = value / 100;

  num get qtd => _qtd;

  set qtd(num value) => _qtd = value;

  num get totalAportado => _precoMedio * qtd;

  List get superiores => _superiores;

  set superiores(List value) => _superiores = value;

  num get precoMedio => _precoMedio;

  set precoMedio(num value) => _precoMedio = value;

  DateTime get dataRecente => _dataRecente;

  set dataRecente(DateTime value) => _dataRecente = value;

  String get tipo => _tipo;

  set tipo(String value) => _tipo = value;

  num get precoRecente => _precoRecente;

  set precoRecente(num value) => _precoRecente = value;

  bool get isAcao => _tipo == "ACAO";
  bool get isETF => _tipo == "ETF";
  bool get isFII => _tipo == "FII";
  bool get isCripto => _tipo == "CRIPTO";
}
