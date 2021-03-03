import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

class AtivoDTO extends AtivoModel {
  CotacaoModel _cotacaoModel;
  double _percentualNaAlocacao;
  double _totalInvestir;

  AtivoDTO(AtivoModel model,
      [this._cotacaoModel,
      this._percentualNaAlocacao = 0,
      this._totalInvestir = 0])
      : super.fromMap(model.toMap());

  AtivoDTO clone() {
    return AtivoDTO(
        AtivoModel.fromMap(super.toMap()),
        CotacaoModel.fromMap(this._cotacaoModel.toMap()),
        this._percentualNaAlocacao,
        this._totalInvestir);
  }

  AtivoModel getModel() {
    return AtivoModel.fromMap(super.toMap());
  }

  CotacaoModel get cotacaoModel => _cotacaoModel;
  set cotacaoModel(value) => _cotacaoModel = value;

  double get totalAportadoAtual => qtd.toDouble() * _cotacaoModel.ultimo;

  double get percentualNaAlocacao => _percentualNaAlocacao;

  String get percentualNaAlocacaoString {
    String aloc =
        GeralUtil.limitaCasasDecimais(percentualNaAlocacao, casasDecimais: 1)
            .toString();
    if (aloc.split('.')[1] == '0') {
      return aloc.split('.')[0];
    }
    return aloc;
  }

  set percentualNaAlocacao(double value) => _percentualNaAlocacao = value;

  double get totalInvestir => _totalInvestir;

  set totalInvestir(double value) => _totalInvestir = value;
}
