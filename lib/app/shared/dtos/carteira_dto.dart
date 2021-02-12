import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

class CarteiraDTO extends CarteiraModel {
  double _totalAportado;
  double _totalAportadoAtual;

  CarteiraDTO(CarteiraModel carteiraModel,
      [this._totalAportado = 0, this._totalAportadoAtual = 0])
      : super(
            carteiraModel.id,
            carteiraModel.idUsuario,
            carteiraModel.descricao,
            carteiraModel.totalDeposito,
            carteiraModel.autoAlocacao);

  CarteiraDTO clone() {
    return CarteiraDTO(CarteiraModel.fromMap(super.toMap()),
        this._totalAportado, this._totalAportadoAtual);
  }

  double getSaldo() {
    return super.totalDeposito.toDouble() - _totalAportado;
  }

  String get saldoString {
    return GeralUtil.limitaCasasDecimais(
            super.totalDeposito.toDouble() - _totalAportado)
        .toString();
  }

  double getTotalAportar() {
    return super.totalDeposito.toDouble() - _totalAportado;
  }

  double get totalAtualizado => super.totalDeposito + rendimentoTotal;

  String get totalAtualizadoString =>
      GeralUtil.limitaCasasDecimais(totalAtualizado).toString();

  ///retorna o total como se ja estivesse aportado (futuro)
  double getTotalAposAporte() {
    return _totalAportadoAtual + getTotalAportar();
  }

  double get rendimentoTotal => _totalAportadoAtual - _totalAportado;
  String get rendimentoTotalString =>
      GeralUtil.limitaCasasDecimais(rendimentoTotal).toString();

  double get rendimentoTotalPercent => (rendimentoTotal * 100) / totalAportado;

  String get rendimentoTotalPercentString {
    String value =
        GeralUtil.limitaCasasDecimais(rendimentoTotalPercent).toString();
    if (value.split('.')[1] == '0') {
      return value.split('.')[0];
    }
    return value;
  }

  double get totalAportado => _totalAportado;

  String get totalAportadoString =>
      GeralUtil.limitaCasasDecimais(_totalAportado).toString();

  set totalAportado(double value) => _totalAportado = value;

  double get totalAportadoAtual => _totalAportadoAtual;

  String get totalAportadoAtualString =>
      GeralUtil.limitaCasasDecimais(_totalAportadoAtual).toString();

  set totalAportadoAtual(double value) => _totalAportadoAtual = value;
}
