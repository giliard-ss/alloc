import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/listener_firestore.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
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
  final ICarteiraService _carteiraService = Modular.get<CarteiraService>();

  @observable
  List<CarteiraModel> carteiras = [];

  Observable<List<CotacaoModel>> cotacoes = SharedMain.cotacoes;

  @action
  Future<void> init() async {
    try {
      SharedMain.startListenerCotacoes();
      //ListenerFirestore.init();
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  @action
  Future refresh() {
    // cotacao = ListenerFirestore.cotacao;
  }

  num getTotalAportado(CarteiraModel carteira) {
    //!deve ser baseado nos ativos
    return 150;
  }
}
