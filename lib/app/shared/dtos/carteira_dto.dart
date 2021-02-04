import 'package:alloc/app/shared/models/carteira_model.dart';

class CarteiraDTO extends CarteiraModel {
  double _totalAportado;
  double _totalAportadoAtual;

  CarteiraDTO(CarteiraModel carteiraModel, this._totalAportado,
      this._totalAportadoAtual)
      : super(
            carteiraModel.id,
            carteiraModel.idUsuario,
            carteiraModel.descricao,
            carteiraModel.totalDeposito,
            carteiraModel.autoAlocacao);

  double getSaldo() {
    return super.totalDeposito.toDouble() - _totalAportado;
  }

  double getTotalAportar() {
    return super.totalDeposito.toDouble() - _totalAportado;
  }

  ///retorna o total como se ja estivesse aportado (futuro)
  double getTotalAposAporte() {
    return _totalAportadoAtual + getTotalAportar();
  }

  double get totalAportado => _totalAportado;

  set totalAportado(double value) => _totalAportado = value;

  double get totalAportadoAtual => _totalAportadoAtual;

  set totalAportadoAtual(double value) => _totalAportadoAtual = value;
}
