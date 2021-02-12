import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';

import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/services/impl/alocacao_service.dart';
import 'package:alloc/app/shared/services/impl/ativo_service.dart';
import 'package:alloc/app/shared/services/impl/carteira_service.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'carteira_controller.g.dart';

@Injectable()
class CarteiraController = _CarteiraControllerBase with _$CarteiraController;

abstract class _CarteiraControllerBase with Store {
  ReactionDisposer _carteirasReactDispose;
  IAlocacaoService _alocacaoService = Modular.get<AlocacaoService>();
  IAtivoService _ativoService = Modular.get<AtivoService>();
  ICarteiraService _carteiraService = Modular.get<CarteiraService>();

  String novaAlocacaoDesc;
  double valorDeposito;
  double valorSaque;

  @observable
  List<AlocacaoDTO> alocacoes = [];
  @observable
  List<AtivoDTO> ativos = [];
  @observable
  CarteiraDTO _carteira;

  @observable
  String errorDialog;

  Future<void> init() async {
    await _loadAlocacoesOuAtivos();
    _startCarteirasReaction();
    refreshAlocacoes();
  }

  void _startCarteirasReaction() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }

    _carteirasReactDispose = SharedMain.createCarteirasReact((e) {
      _carteira = SharedMain.getCarteira(_carteira.id);
      refreshAlocacoes();
      _loadAtivos();
    });
  }

  Future<bool> salvarNovaAlocacao() async {
    try {
      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs.add(AlocacaoModel(null, SharedMain.usuario.id, novaAlocacaoDesc,
          null, _carteira.id, null));
      await _alocacaoService.save(alocs, _carteira.autoAlocacao);
      await SharedMain.notifyAddDelAlocacao();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      errorDialog = "Falha ao salvar nova alocação.";
      return false;
    }
  }

  void refreshAlocacoes() {
    List<AlocacaoDTO> list = SharedMain.getAlocacoesByCarteiraId(carteira.id);
    list.forEach(
        (e) => e.percentualNaAlocacao = _getPercentualAtualAloc(e, list));
    list.sort(
        (e1, e2) => e2.percentualNaAlocacao.compareTo(e1.percentualNaAlocacao));
    alocacoes = list;
  }

  Future<bool> salvarDeposito() async {
    try {
      CarteiraModel updated = CarteiraModel.fromMap(_carteira.toMap());
      updated.totalDeposito = updated.totalDeposito.toDouble() + valorDeposito;
      await _carteiraService.update(updated);
      await SharedMain.notifyUpdateCarteira();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      errorDialog = "Falha ao salvar nova alocação.";
      return false;
    }
  }

  Future<bool> salvarSaque() async {
    try {
      CarteiraModel updated = CarteiraModel.fromMap(_carteira.toMap());
      updated.totalDeposito = updated.totalDeposito.toDouble() - valorSaque;
      if (updated.totalDeposito < 0) {
        errorDialog = "Saldo disponível ${_carteira.totalDeposito}.";
        return false;
      }

      await _carteiraService.update(updated);
      await SharedMain.notifyUpdateCarteira();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      errorDialog = "Falha ao salvar nova alocação.";
      return false;
    }
  }

  Future<String> excluir(AtivoDTO ativoDTO) async {
    try {
      List<AtivoDTO> list = List.from(ativos);
      list = list.where((e) => e.id != ativoDTO.id).toList();
      double media =
          double.parse(((100 / list.length) / 100).toStringAsFixed(2));
      list.forEach((a) => a.alocacao = media);

      List<AtivoModel> models = [];
      list.forEach((e) => models.add(e.getModel()));
      await _ativoService.delete(ativoDTO.getModel(), models);
      await SharedMain.notifyAddDelAtivo();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir ativo!";
    }
  }

  Future<String> excluirCarteira() async {
    try {
      await _carteiraService.delete(_carteira.id);
      await SharedMain.notifyAddDelCarteira();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir carteira!";
    }
  }

  Future<String> excluirAlocacao(AlocacaoDTO alocacaoDTO) async {
    try {
      if (SharedMain.alocacaoPossuiAtivos(alocacaoDTO.id)) {
        return "Alocação possui ativos!";
      }

      if (SharedMain.alocacaoPossuiSubAlocacao(alocacaoDTO.id)) {
        return "Alocação possui sub-alocações!";
      }

      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs = alocs.where((e) => e.id != alocacaoDTO.id).toList();
      double media =
          double.parse(((100 / alocs.length) / 100).toStringAsFixed(2));
      alocs.forEach((a) => a.alocacao = media);

      await _alocacaoService.delete(alocacaoDTO.id, alocs);
      refreshAlocacoes();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir alocação!";
    }
  }

  Future<void> _loadAlocacoesOuAtivos() async {
    refreshAlocacoes();
    if (alocacoes.isEmpty) {
      _loadAtivos();
    }
  }

  double _getPercentualAtualAloc(
      AlocacaoDTO aloc, List<AlocacaoDTO> alocacoes) {
    double total = 0;
    alocacoes.forEach((e) => total = total + e.totalAportadoAtual);
    double percent = (aloc.totalAportadoAtual * 100) / total;
    return percent;
  }

  double _getPercentualAtualAtivo(AtivoDTO ativo, List<AtivoDTO> ativos) {
    double total = 0;
    ativos.forEach((e) => total = total + e.totalAportadoAtual);
    double percent = (ativo.totalAportadoAtual * 100) / total;
    return percent;
  }

  void _loadAtivos() {
    List<AtivoDTO> list = SharedMain.getAtivosByCarteira(_carteira.id);
    list.forEach(
        (e) => e.percentualNaAlocacao = _getPercentualAtualAtivo(e, list));

    list.sort(
        (e1, e2) => e2.percentualNaAlocacao.compareTo(e1.percentualNaAlocacao));
    ativos = list;
  }

  void limparErrorDialog() {
    errorDialog = null;
  }

  CotacaoModel getCotacao(String papel) {
    return SharedMain.getCotacao(papel);
  }

  void setCarteira(String carteiraId) {
    _carteira = SharedMain.getCarteira(carteiraId);
  }

  String get title => _carteira.descricao;

  CarteiraDTO get carteira => _carteira;

  void dispose() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }
  }
}
