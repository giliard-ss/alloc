import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
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
  Future<bool> salvarNovaAlocacao(List<AlocacaoDTO> alocacoes) async {
    try {
      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs.add(AlocacaoModel(null, SharedMain.usuario.id, novaAlocacaoDesc,
          null, alocacaoAtual.idCarteira, alocacaoAtual.id));

      await _alocacaoService.save(alocs, alocacaoAtual.autoAlocacao);
      await SharedMain.notifyAddDelAlocacao();
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
      double media =
          double.parse(((100 / list.length) / 100).toStringAsFixed(2));
      list.forEach((a) => a.alocacao = media);
      await _ativoService.delete(ativoExcluir, list);
      await SharedMain.notifyAddDelAtivo();

      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir ativo!";
    }
  }

  Future<String> excluirAlocacao(
      AlocacaoDTO alocacaoExcluir, List<AlocacaoDTO> alocacoes) async {
    try {
      if (SharedMain.alocacaoPossuiAtivos(alocacaoExcluir.id)) {
        return "Alocação possui ativos!";
      }
      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs = alocs.where((e) => e.id != alocacaoExcluir.id).toList();
      double media =
          double.parse(((100 / alocs.length) / 100).toStringAsFixed(2));
      alocs.forEach((a) => a.alocacao = media);
      await _alocacaoService.delete(alocacaoExcluir.id, alocs);
      await SharedMain.notifyAddDelAlocacao();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir alocação!";
    }
  }
}
