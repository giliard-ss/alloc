import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
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
  Future<bool> salvarNovaAlocacao(List<AlocacaoDTO> alocacoes) async {
    try {
      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs.add(AlocacaoModel(null, AppCore.usuario.id, novaAlocacaoDesc, null,
          alocacaoAtual.idCarteira, alocacaoAtual.id));

      await _alocacaoService.save(alocs, alocacaoAtual.autoAlocacao);
      await AppCore.notifyAddDelAlocacao();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      novaAlocacaoError = "Falha ao salvar nova alocação.";
      return false;
    }
  }

  Future<String> excluir(
      AtivoModel ativoExcluir, List<AtivoModel> ativos) async {
    try {
      List<AtivoModel> list = List.from(ativos);
      list = list.where((e) => e.id != ativoExcluir.id).toList();

      await _ativoService.delete(
          ativoExcluir, list, alocacaoAtual.autoAlocacao);
      await AppCore.notifyAddDelAtivo();

      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir ativo!";
    }
  }

  Future<String> excluirAlocacao(
      AlocacaoDTO alocacaoExcluir, List<AlocacaoDTO> alocacoes) async {
    try {
      if (AppCore.alocacaoPossuiAtivos(alocacaoExcluir.id)) {
        return "Alocação possui ativos!";
      }
      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs = alocs.where((e) => e.id != alocacaoExcluir.id).toList();

      await _alocacaoService.delete(
          alocacaoExcluir.id, alocs, alocacaoAtual.autoAlocacao);
      await AppCore.notifyAddDelAlocacao();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir alocação!";
    }
  }
}
