import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/services/impl/alocacao_service.dart';
import 'package:alloc/app/shared/services/impl/ativo_service.dart';
import 'package:alloc/app/shared/services/impl/carteira_service.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'dtos/alocacao_dto.dart';

part 'carteira_controller.g.dart';

@Injectable()
class CarteiraController = _CarteiraControllerBase with _$CarteiraController;

abstract class _CarteiraControllerBase with Store {
  ReactionDisposer _carteirasReactDispose;
  IAlocacaoService _alocacaoService = Modular.get<AlocacaoService>();
  IAtivoService _ativoService = Modular.get<AtivoService>();
  ICarteiraService _carteiraService = Modular.get<CarteiraService>();
  Observable<List<AlocacaoDTO>> allAlocacoes =
      Observable<List<AlocacaoDTO>>([]);

  String novaAlocacaoDesc;
  double valorDeposito;
  double valorSaque;

  @observable
  List<AlocacaoDTO> alocacoes = [];
  @observable
  List<AtivoModel> ativos = [];
  @observable
  CarteiraDTO _carteira;

  @observable
  String errorDialog;

  Future<void> init() async {
    await _loadAlocacoesOuAtivos();
    _startCarteirasReaction();
    refreshAlocacoes();
  }

  Future<bool> salvarNovaAlocacao() async {
    try {
      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs
          .add(AlocacaoModel(null, novaAlocacaoDesc, null, _carteira.id, null));
      await _alocacaoService.save(alocs, _carteira.autoAlocacao);
      await loadAlocacoes();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      errorDialog = "Falha ao salvar nova alocação.";
      return false;
    }
  }

  Future<bool> salvarDeposito() async {
    try {
      CarteiraModel updated = CarteiraModel.fromMap(_carteira.toMap());
      updated.totalDeposito = updated.totalDeposito.toDouble() + valorDeposito;
      await _carteiraService.update(updated);
      await SharedMain.refreshCarteiras();
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
      await SharedMain.refreshCarteiras();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      errorDialog = "Falha ao salvar nova alocação.";
      return false;
    }
  }

  Future<String> excluir(AtivoModel ativoModel) async {
    try {
      List<AtivoModel> list = List.from(ativos);
      list = list.where((e) => e.id != ativoModel.id).toList();
      double media =
          double.parse(((100 / list.length) / 100).toStringAsFixed(2));
      list.forEach((a) => a.alocacao = media);
      await _ativoService.delete(ativoModel, list);
      await SharedMain.refreshAtivos();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir ativo!";
    }
  }

  Future<String> excluirCarteira() async {
    try {
      await _carteiraService.delete(_carteira.id);
      await SharedMain.refreshCarteiras();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir carteira!";
    }
  }

  bool alocacaoPossuiSubAlocacao(String idAlocacao) {
    return allAlocacoes.value
        .where((e) => e.idSuperior == idAlocacao)
        .isNotEmpty;
  }

  Future<String> excluirAlocacao(AlocacaoDTO alocacaoDTO) async {
    try {
      if (SharedMain.alocacaoPossuiAtivos(alocacaoDTO.id)) {
        return "Alocação possui ativos!";
      }

      if (alocacaoPossuiSubAlocacao(alocacaoDTO.id)) {
        return "Alocação possui sub-alocações!";
      }

      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs = alocs.where((e) => e.id != alocacaoDTO.id).toList();
      double media =
          double.parse(((100 / alocs.length) / 100).toStringAsFixed(2));
      alocs.forEach((a) => a.alocacao = media);

      await _alocacaoService.delete(alocacaoDTO.id, alocs);
      await loadAlocacoes();
      return null;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir alocação!";
    }
  }

  Future<void> _loadAlocacoesOuAtivos() async {
    await loadAlocacoes();
    if (alocacoes.isEmpty) {
      _loadAtivos();
    }
  }

  void _loadAtivos() {
    ativos = SharedMain.ativos
        .where(
          (e) => e.idCarteira == _carteira.id,
        )
        .toList();
  }

  void limparErrorDialog() {
    errorDialog = null;
  }

  Future<void> loadAlocacoes() async {
    List<AlocacaoDTO> result = [];
    List<AlocacaoModel> list =
        await _alocacaoService.getAlocacoes(_carteira.id);
    list.forEach((a) => result.add(AlocacaoDTO(a)));
    allAlocacoes.value = result;
    refreshAlocacoes();
  }

  void _startCarteirasReaction() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }

    _carteirasReactDispose =
        SharedMain.createCarteirasReact((List<CarteiraDTO> carteiras) {
      _refreshCarteira();
      _loadAtivos();
    });
  }

  void _refreshCarteira() {
    _carteira = SharedMain.getCarteira(_carteira.id);
    refreshAlocacoes();
  }

  void refreshAlocacoes() {
    List<AlocacaoDTO> result = [];
    for (AlocacaoDTO aloc in allAlocacoes.value) {
      aloc.totalAportado = SharedMain.getTotalAportadoAtivosByAlocacao(aloc.id);
      aloc.totalAportadoAtual = aloc.totalAportado +
          (SharedMain.getRendimentoAtivosByAlocacao(aloc.id));

      double totalAposAporte =
          _carteira.getTotalAposAporte() * getAlocacaoReal(aloc);

      aloc.totalInvestir = totalAposAporte - aloc.totalAportadoAtual;

      result.add(aloc);
    }
    allAlocacoes.value = result;
    alocacoes = result.where((i) => i.idSuperior == null).toList();
  }

  //Calcula a porcentagem real levando em conta todos as alocacoes superiores
  // ex: aloc3 * aloc2 * aloc1 = alocacao real
  double getAlocacaoReal(AlocacaoDTO aloc) {
    double result = 1;
    AlocacaoDTO prox = aloc;
    while (true) {
      result = result * prox.alocacao.toDouble();
      if (StringUtil.isEmpty(prox.idSuperior)) {
        break;
      } else {
        prox = allAlocacoes.value.where((e) => e.id == prox.idSuperior).first;
      }
    }
    return result;
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
