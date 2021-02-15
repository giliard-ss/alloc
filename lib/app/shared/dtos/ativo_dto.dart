import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';

class AtivoDTO extends AtivoModel {
  double _ultimaCotacao;
  double _percentualNaAlocacao;

  AtivoDTO(AtivoModel model, [this._ultimaCotacao, this._percentualNaAlocacao])
      : super.fromMap(model.toMap());

  AtivoDTO clone() {
    return AtivoDTO(AtivoModel.fromMap(super.toMap()), this._ultimaCotacao,
        this._percentualNaAlocacao);
  }

  AtivoModel getModel() {
    return AtivoModel.fromMap(super.toMap());
  }

  double get totalAportadoAtual => qtd.toInt() * _ultimaCotacao;

  double get ultimaCotacao => _ultimaCotacao;

  String get ultimaCotacaoString =>
      GeralUtil.limitaCasasDecimais(ultimaCotacao).toString();

  set ultimaCotacao(double value) => _ultimaCotacao = value;

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
}
