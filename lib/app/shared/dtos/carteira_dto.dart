import 'package:alloc/app/shared/models/carteira_model.dart';

class CarteiraDTO extends CarteiraModel {
  double _totalAportado;
  double _totalAportadoAtual;

  CarteiraDTO(CarteiraModel carteiraModel, this._totalAportado,
      this._totalAportadoAtual)
      : super(carteiraModel.id, carteiraModel.idUsuario,
            carteiraModel.descricao, carteiraModel.totalDeposito);

  double getSaldo() {
    return super.totalDeposito.toDouble() - _totalAportado;
  }

  double get totalAportado => _totalAportado;

  set totalAportado(double value) => _totalAportado = value;

  double get totalAportadoAtual => _totalAportadoAtual;

  set totalAportadoAtual(double value) => _totalAportadoAtual = value;
}
