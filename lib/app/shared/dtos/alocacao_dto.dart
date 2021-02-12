import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

class AlocacaoDTO extends AlocacaoModel {
  double _totalAportado;
  double _totalAportadoAtual;
  double _totalInvestir;
  double _percentualNaAlocacao;

  AlocacaoDTO(AlocacaoModel model,
      [this._totalAportado = 0,
      this._totalAportadoAtual = 0,
      this._totalInvestir = 0,
      this._percentualNaAlocacao = 0])
      : super.fromMap(model.toMap());

  AlocacaoDTO clone() {
    return AlocacaoDTO(
        AlocacaoModel.fromMap(super.toMap()),
        this._totalAportado,
        this._totalAportadoAtual,
        this._totalInvestir,
        this.percentualNaAlocacao);
  }

  double get totalAposInvestir => _totalAportadoAtual + _totalInvestir;

  double get totalAportado => _totalAportado;

  double get rendimentoPercent => (rendimento * 100) / _totalAportado;

  String get rendimentoPercentString =>
      GeralUtil.limitaCasasDecimais(rendimentoPercent).toString();

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

  double get percentualNaAlocacao => _percentualNaAlocacao;

  String get percentualNaAlocacaoString =>
      GeralUtil.limitaCasasDecimais(percentualNaAlocacao, casasDecimais: 1)
          .toString();

  set percentualNaAlocacao(double value) => _percentualNaAlocacao = value;
}
