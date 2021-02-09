import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

class AlocacaoDTO extends AlocacaoModel {
  double _totalAportado;
  double _totalAportadoAtual;
  double _totalInvestir;

  AlocacaoDTO(AlocacaoModel model,
      [this._totalAportado = 0,
      this._totalAportadoAtual = 0,
      this._totalInvestir = 0])
      : super.fromMap(model.toMap());

  double get totalAposInvestir => _totalAportadoAtual + _totalInvestir;

  double get totalAportado => _totalAportado;

  double get rendimento => _totalAportadoAtual - totalAportado;

  String get rendimentoString =>
      GeralUtil.limitaCasasDecimais(rendimento).toString();

  String get totalAportadoString =>
      GeralUtil.limitaCasasDecimais(_totalAportado).toString();

  set totalAportado(double value) => _totalAportado = value;

  double get totalAportadoAtual => _totalAportadoAtual;

  String get totalAportadoAtualString =>
      GeralUtil.limitaCasasDecimais(_totalAportadoAtual).toString();

  set totalAportadoAtual(double value) => _totalAportadoAtual = value;

  double get totalInvestir => _totalInvestir;

  String get totalInvestirString =>
      GeralUtil.limitaCasasDecimais(_totalInvestir).toString();

  set totalInvestir(double value) => _totalInvestir = value;
}
