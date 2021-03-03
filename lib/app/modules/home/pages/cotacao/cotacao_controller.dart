import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_core.dart';

part 'cotacao_controller.g.dart';

@Injectable()
class CotacaoController = _CotacaoControllerBase with _$CotacaoController;

abstract class _CotacaoControllerBase with Store {
  @observable
  List<AtivoDTO> acoes = [];

  void init() {
    try {
      loadAcoes();
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  void loadAcoes() {
    acoes = AppCore.allAtivos.where((e) => e.isAcao).toList();
    acoes.sort((e1, e2) => e2.cotacaoModel.variacaoDouble
        .compareTo(e1.cotacaoModel.variacaoDouble));
  }
}
