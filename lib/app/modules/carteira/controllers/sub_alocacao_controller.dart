import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/services/impl/alocacao_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'sub_alocacao_controller.g.dart';

@Injectable()
class SubAlocacaoController = _SubAlocacaoControllerBase
    with _$SubAlocacaoController;

abstract class _SubAlocacaoControllerBase with Store {
  IAlocacaoService _alocacaoService = Modular.get<AlocacaoService>();
  CarteiraController _carteiraController = Modular.get();
  AlocacaoDTO alocacaoAtual;
  String novaAlocacaoDesc;

  @observable
  String novaAlocacaoError;

  Future<void> init() async {
    novaAlocacaoDesc = null;
    novaAlocacaoError = null;
  }

  @action
  Future<bool> salvarNovaAlocacao() async {
    try {
      await _alocacaoService.create(
          novaAlocacaoDesc, alocacaoAtual.idCarteira, alocacaoAtual.id);
      await _carteiraController.loadAlocacoes();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      novaAlocacaoError = "Falha ao salvar nova alocação.";
      return false;
    }
  }
}
