import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/services/impl/carteira_service.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  ICarteiraService _carteiraService = Modular.get<CarteiraService>();
  ReactionDisposer _carteirasReactDispose;
  String descricao;

  @observable
  String error;

  @observable
  List<CarteiraDTO> carteiras = [];

  @observable
  List<AtivoDTO> acoes = [];

  @action
  Future<void> init() async {
    try {
      carteiras = AppCore.carteiras;
      loadAcoes();
      _startCarteirasReaction();
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  void loadAcoes() {
    List<AtivoDTO> list = AppCore.allAtivos.where((e) => e.isAcao).toList();
    list.sort((e1, e2) => e2.cotacaoModel.variacaoDouble
        .compareTo(e1.cotacaoModel.variacaoDouble));
    list = list.sublist(0, 5);
    acoes = list;
  }

  CotacaoModel getCotacaoIndiceByTipo(TipoAtivoEnum tipo) {
    if (tipo == TipoAtivoEnum.ACAO) return AppCore.getCotacao("IBOV");
    return CotacaoModel("--", 0.0, 0.0);
  }

  double getVariacaoTotalAcoes() {
    double totalAbertura = 0.0;
    double totalAtual = 0.0;
    AppCore.allAtivos.where((e) => e.isAcao).forEach((e) {
      double precoAbertura =
          (e.cotacaoModel.ultimo * 100) / (100 + e.cotacaoModel.variacaoDouble);

      totalAbertura += precoAbertura * e.qtd;
      totalAtual += e.cotacaoModel.ultimo * e.qtd;
    });

    double percentual = ((totalAtual * 100) / totalAbertura) - 100;
    return GeralUtil.limitaCasasDecimais(percentual);
  }

  @action
  Future<bool> salvarNovaCarteira() async {
    try {
      await _carteiraService.create(descricao);
      await AppCore.notifyAddDelCarteira();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      error = "Falha ao salvar nova carteira.";
      return false;
    }
  }

  void _startCarteirasReaction() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }

    _carteirasReactDispose = AppCore.createCarteirasReact((e) {
      this.carteiras = AppCore.carteiras;
      loadAcoes();
    });
  }

  @action
  Future refresh() async {
    // await SharedMain.refreshCarteiras();
  }
}
