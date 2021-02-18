import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/services/impl/carteira_service.dart';
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
  List<AtivoDTO> ativos = [];

  @action
  Future<void> init() async {
    try {
      carteiras = AppCore.carteiras;
      ativos = AppCore.allAtivos;
      _startCarteirasReaction();
    } catch (e) {
      LoggerUtil.error(e);
    }
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
      this.ativos = AppCore.allAtivos;
    });
  }

  @action
  Future refresh() async {
    // await SharedMain.refreshCarteiras();
  }
}
