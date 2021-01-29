import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/services/impl/alocacao_service.dart';
import 'package:alloc/app/shared/services/impl/ativo_service.dart';
import 'package:alloc/app/shared/shared_main.dart';
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
  IAtivoService _ativoService = Modular.get<AtivoService>();
  AlocacaoDTO alocacaoAtual;
  String novaAlocacaoDesc;
  AtivoModel novoAtivo;

  @observable
  String novaAlocacaoError;

  Future<void> init() async {
    novaAlocacaoDesc = null;
    novaAlocacaoError = null;
    novoAtivo = AtivoModel();
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

  Future<String> excluir(AtivoModel ativoModel) async {
    try {
      await _ativoService.delete(ativoModel);
      await SharedMain.refreshAtivos();

      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir ativo!";
    }
  }

  Future<String> excluirAlocacao(AlocacaoDTO alocacaoDTO) async {
    try {
      if (SharedMain.alocacaoPossuiAtivos(alocacaoDTO.id)) {
        return "Alocação possui ativos!";
      }
      await _alocacaoService.delete(alocacaoDTO.id);
      await _carteiraController.loadAlocacoes();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir alocação!";
    }
  }
}
