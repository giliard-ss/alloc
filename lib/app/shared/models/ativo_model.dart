import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

class AtivoModel {
  String _id;
  String _idUsuario;
  String _papel;
  String _idCarteira;
  num _alocacao;
  num _qtd;
  String _tipo;
  List _superiores;
  num _totalAplicado;
  String _indexador;
  num _vencimento;
  double _rentabilidade;

  AtivoModel() {
    this.superiores = [];
  }

  AtivoModel.fromMap(Map map) {
    this._id = map['id'];
    this._idUsuario = map['idUsuario'];
    this._papel = map['papel'];
    this._idCarteira = map['idCarteira'];
    this._alocacao = map['alocacao'];
    this._qtd = map['qtd'];
    this._vencimento = map['vencimento'];
    this._tipo = map['tipo'];
    this._totalAplicado = map['totalAplicado'];
    this._rentabilidade = map['rentabilidade'];
    this._indexador = map['indexador'];

    this._superiores = List.generate(map['superiores'].length, (i) {
      return map['superiores'][i];
    });
  }

  AtivoModel.fromAplicacaoRendaVariavel(
      AplicacaoRendaVariavel aplicacaoRendaVariavel) {
    this._idCarteira = aplicacaoRendaVariavel.carteiraId;
    this._idUsuario = aplicacaoRendaVariavel.usuarioId;
    this._papel = aplicacaoRendaVariavel.papel;
    this._totalAplicado = aplicacaoRendaVariavel.valor;
    this._qtd = aplicacaoRendaVariavel.qtd;
    this._superiores = aplicacaoRendaVariavel.superiores;
    this._tipo = aplicacaoRendaVariavel.tipoAtivo;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'idUsuario': this._idUsuario,
      'papel': this._papel,
      'idCarteira': this._idCarteira,
      'alocacao': this._alocacao,
      'qtd': this._qtd,
      'totalAplicado': this._totalAplicado,
      'tipo': this._tipo,
      'superiores': this._superiores,
      'rentabilidade': this._rentabilidade,
      'indexador': this._indexador,
      'vencimento': this._vencimento
    };
  }

  bool get isAcao => _tipo == "ACAO";
  bool get isETF => _tipo == "ETF";
  bool get isFII => _tipo == "FII";
  bool get isCripto => _tipo == "CRIPTO";

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

  num get totalAportado => _totalAplicado;

  List get superiores => _superiores;

  set superiores(List value) => _superiores = value;

  num get precoMedio => _totalAplicado / qtd;

  String get tipo => _tipo;

  set tipo(String value) => _tipo = value;

  get totalAplicado => this._totalAplicado;

  set totalAplicado(value) => this._totalAplicado = value;

  get indexador => this._indexador;

  set indexador(value) => this._indexador = value;

  get vencimento => this._vencimento;

  set vencimento(value) => this._vencimento = value;

  get rentabilidade => this._rentabilidade;

  set rentabilidade(value) => this._rentabilidade = value;
}
