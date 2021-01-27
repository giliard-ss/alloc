import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/listener_firestore.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/services/impl/alocacao_service.dart';
import 'package:alloc/app/shared/services/impl/carteira_service.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/exception_util.dart';
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

  @action
  Future<void> init() async {
    try {
      carteiras = SharedMain.carteiras;
      _startCarteirasReaction();
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  @action
  Future<bool> salvarNovaCarteira() async {
    try {
      await _carteiraService.create(descricao);
      await SharedMain.refreshCarteiras();
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

    _carteirasReactDispose =
        SharedMain.createCarteirasReact((List<CarteiraDTO> carteiras) {
      this.carteiras = carteiras;
    });
  }

  @action
  Future refresh() async {
    // await SharedMain.refreshCarteiras();
  }
}
