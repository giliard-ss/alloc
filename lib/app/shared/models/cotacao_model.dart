import 'package:alloc/app/shared/utils/geral_util.dart';

class CotacaoModel {
  String _id;
  num _ultimo;
  num _variacao;

  CotacaoModel(this._id, this._ultimo, this._variacao);

  CotacaoModel.fromMap(Map map) {
    this._id = map['id'];
    this._ultimo = map['ultimo'];
    this._variacao = map['variacao'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'ultimo': this._ultimo,
      'variacao': this._variacao,
    };
  }

  String get id => _id;

  set id(String value) => _id = value;

  num get ultimo => _ultimo;

  String get ultimoString =>
      GeralUtil.limitaCasasDecimais(ultimo.toDouble()).toString();

  set ultimo(num value) => _ultimo = value;

  set variacao(num value) => _variacao = value;

  num get variacao => _variacao;

  double get variacaoDouble => _variacao.toDouble();
}
