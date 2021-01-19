import 'package:alloc/app/shared/models/alocacao_model.dart';

class AlocacaoDTO extends AlocacaoModel {
  double _totalAportado;
  double _totalAportadoAtual;
  double _totalInvestir;

  AlocacaoDTO(AlocacaoModel model,
      [this._totalAportado = 0,
      this._totalAportadoAtual = 0,
      this._totalInvestir = 0])
      : super.fromMap(model.toMap());

  double get totalAportado => _totalAportado;

  set totalAportado(double value) => _totalAportado = value;

  double get totalAportadoAtual => _totalAportadoAtual;

  set totalAportadoAtual(double value) => _totalAportadoAtual = value;

  double get totalInvestir => _totalInvestir;

  set totalInvestir(double value) => _totalInvestir = value;
}
