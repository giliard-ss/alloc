import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_core.dart';

part 'cotacao_controller.g.dart';

@Injectable()
class CotacaoController = _CotacaoControllerBase with _$CotacaoController;

abstract class _CotacaoControllerBase with Store {
  @observable
  List<AtivoDTO> ativos = [];

  void init(String tipo) {
    try {
      loadAtivos(tipo);
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  void loadAtivos(String tipo) {
    ativos = AppCore.allAtivos.where((e) => e.tipo == tipo).toList();
    ativos.sort((e1, e2) => e2.cotacaoModel.variacaoDouble
        .compareTo(e1.cotacaoModel.variacaoDouble));
  }
}
