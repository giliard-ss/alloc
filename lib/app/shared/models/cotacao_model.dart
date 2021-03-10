import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

class CotacaoModel {
  String _id;
  num _ultimo;
  num _variacao;
  num _date;

  CotacaoModel(this._id, this._ultimo, this._variacao, [this._date]);

  CotacaoModel.fromMap(Map map) {
    this._id = map['id'];
    this._ultimo = map['ultimo'];
    this._variacao = map['variacao'];
    this._date = map['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'ultimo': this._ultimo,
      'variacao': this._variacao,
      'date': this._date,
    };
  }

  double get precoAbertura => (ultimo * 100) / (100 + variacaoDouble);

  double get precoAberturaHoje => (ultimo * 100) / (100 + variacaoHoje);

  String get id => _id;

  set id(String value) => _id = value;

  num get ultimo => _ultimo;

  String get ultimoString =>
      GeralUtil.limitaCasasDecimais(ultimo.toDouble()).toString();

  set ultimo(num value) => _ultimo = value;

  set variacao(num value) => _variacao = value;

  num get variacao => _variacao;

  double get variacaoDouble => _variacao.toDouble();

  double get variacaoHoje {
    if (_date == null) return 0.0;
    DateTime data = DateTime.fromMillisecondsSinceEpoch(_date.toInt());
    if (DateUtil.equals(
      data,
      DateTime.now(),
    )) return variacaoDouble;
    return 0.0;
  }

  DateTime get date {
    if (_date == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(_date.toInt());
  }
}
