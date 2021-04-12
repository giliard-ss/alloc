import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

class CarteiraDTO extends CarteiraModel {
  double _totalAportado;
  double _totalAportadoAtual;

  CarteiraDTO(CarteiraModel carteiraModel, [this._totalAportado = 0, this._totalAportadoAtual = 0])
      : super(carteiraModel.id, carteiraModel.idUsuario, carteiraModel.descricao,
            carteiraModel.totalDeposito, carteiraModel.totalProventos, carteiraModel.autoAlocacao);

  CarteiraDTO clone() {
    return CarteiraDTO(
        CarteiraModel.fromMap(super.toMap()), this._totalAportado, this._totalAportadoAtual);
  }

  double get saldo {
    return _totalEntradaDinheiro() - _totalAportado;
  }

  double getTotalAportar() {
    return saldo - _totalAportado;
  }

  double _totalEntradaDinheiro() {
    return super.totalDeposito.toDouble() + super.totalProventos.toDouble();
  }

  double get totalAtualizado => _totalEntradaDinheiro() + rendimentoTotal;

  ///retorna o total como se ja estivesse aportado (futuro)
  double getTotalAposAporte() {
    return _totalAportadoAtual + getTotalAportar();
  }

  double get rendimentoTotal => _totalAportadoAtual - _totalAportado;

  double get rendimentoTotalPercent {
    if (totalAportado == 0) return 0;
    return (rendimentoTotal * 100) / totalAportado;
  }

  String get rendimentoTotalPercentString {
    String value = GeralUtil.limitaCasasDecimais(rendimentoTotalPercent).toString();
    if (value.split('.')[1] == '0') {
      return value.split('.')[0];
    }
    return value;
  }

  double get totalAportado => _totalAportado;

  set totalAportado(double value) => _totalAportado = value;

  double get totalAportadoAtual => _totalAportadoAtual;

  set totalAportadoAtual(double value) => _totalAportadoAtual = value;
}
