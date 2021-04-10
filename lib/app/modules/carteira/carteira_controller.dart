import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/backup_proventos.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/models/evento_deposito.dart';
import 'package:alloc/app/shared/models/evento_provento.dart';
import 'package:alloc/app/shared/models/evento_saque.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/services/event_service.dart';
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
  IEventService _eventService = Modular.get<EventService>();

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
    try {
      await _loadAlocacoesOuAtivos();
      _startCarteirasReaction();
      refreshAlocacoes();
    } catch (e, stacktrace) {
      print(stacktrace);
    }
  }

  void _startCarteirasReaction() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }

    _carteirasReactDispose = AppCore.createCarteirasReact((e) {
      _carteira = AppCore.getCarteira(_carteira.id);
      refreshAlocacoes();
      _loadAtivos();
    });
  }

  Future<bool> salvarNovaAlocacao() async {
    try {
      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs
          .add(AlocacaoModel(null, AppCore.usuario.id, novaAlocacaoDesc, null, _carteira.id, null));
      await _alocacaoService.save(alocs, _carteira.autoAlocacao);
      await AppCore.notifyAddDelAlocacao();
      return true;
    } on ApplicationException catch (e) {
      errorDialog = e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      errorDialog = "Falha ao salvar nova alocação.";
    }
    return false;
  }

  void refreshAlocacoes() {
    List<AlocacaoDTO> list = AppCore.getAlocacoesByCarteiraId(carteira.id);
    list.forEach((e) => e.percentualNaAlocacao = _getPercentualAtualAloc(e, list));
    list.sort((e1, e2) => e2.percentualNaAlocacao.compareTo(e1.percentualNaAlocacao));
    alocacoes = list;
  }

  Future<bool> salvarDeposito() async {
    try {
      if (valorDeposito == null || valorDeposito <= 0)
        throw new ApplicationException("Valor de depósito inválido!");

      EventoDeposito deposito = new EventoDeposito(null, DateTime.now().millisecondsSinceEpoch,
          _carteira.id, AppCore.usuario.id, valorDeposito);

      _eventService.save(deposito);

      await AppCore.notifyUpdateCarteira();
      return true;
    } on ApplicationException catch (e) {
      errorDialog = e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      errorDialog = "Falha ao salvar nova alocação.";
    }
    return false;
  }

  Future<bool> salvarSaque() async {
    try {
      if (valorSaque == null || valorSaque <= 0)
        throw new ApplicationException("Valor de saque inválido!");

      if (carteira.saldo < valorSaque)
        throw new ApplicationException("Valor de saque acima do saldo!");

      EventoSaque saque = new EventoSaque(null, DateTime.now().millisecondsSinceEpoch, _carteira.id,
          AppCore.usuario.id, valorSaque);

      _eventService.save(saque);
      await AppCore.notifyUpdateCarteira();
      return true;
    } on ApplicationException catch (e) {
      errorDialog = e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      errorDialog = "Falha ao salvar nova alocação.";
    }
    return false;
  }

  Future<String> excluir(AtivoDTO ativoDTO) async {
    try {
      List<AtivoDTO> list = List.from(ativos);
      list = list.where((e) => e.id != ativoDTO.id).toList();

      List<AtivoModel> models = [];
      list.forEach((e) => models.add(e.getModel()));
      await _ativoService.delete(ativoDTO.getModel(), models, _carteira.autoAlocacao);
      await AppCore.notifyAddDelAtivo();
      return null;
    } on ApplicationException catch (e) {
      return e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir ativo!";
    }
  }

  Future<String> excluirCarteira() async {
    try {
      await _carteiraService.delete(_carteira.id);
      await AppCore.notifyAddDelCarteira();
      return null;
    } on ApplicationException catch (e) {
      return e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir carteira!";
    }
  }

  Future<String> excluirAlocacao(AlocacaoDTO alocacaoDTO) async {
    try {
      if (AppCore.alocacaoPossuiAtivos(alocacaoDTO.id)) {
        return "Alocação possui ativos!";
      }

      if (AppCore.alocacaoPossuiSubAlocacao(alocacaoDTO.id)) {
        return "Alocação possui sub-alocações!";
      }

      List<AlocacaoModel> alocs = List.from(alocacoes);
      alocs = alocs.where((e) => e.id != alocacaoDTO.id).toList();

      await _alocacaoService.delete(alocacaoDTO.id, alocs, _carteira.autoAlocacao);
      await AppCore.notifyAddDelAlocacao();
      refreshAlocacoes();
      return null;
    } on ApplicationException catch (e) {
      return e.toString();
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

  double _getPercentualAtualAloc(AlocacaoDTO aloc, List<AlocacaoDTO> alocacoes) {
    if (aloc.totalAportadoAtual == 0) return 0;
    double total = 0;
    alocacoes.forEach((e) => total = total + e.totalAportadoAtual);
    double percent = (aloc.totalAportadoAtual * 100) / total;
    return percent;
  }

  double _getPercentualAtualAtivo(AtivoDTO ativo, List<AtivoDTO> ativos) {
    if (ativo.totalAportadoAtual == 0) return 0;
    double total = 0;
    ativos.forEach((e) => total = total + e.totalAportadoAtual);
    double percent = (ativo.totalAportadoAtual * 100) / total;
    return percent;
  }

  void _loadAtivos() {
    List<AtivoDTO> list = AppCore.getAtivosByCarteira(_carteira.id);
    list.forEach((e) {
      e.percentualNaAlocacao = _getPercentualAtualAtivo(e, list);

      double totalAposAporte = carteira.getTotalAposAporte() * 1;

      e.totalInvestir = totalAposAporte - e.totalAportadoAtual;
    });

    list.sort((e1, e2) => e2.percentualNaAlocacao.compareTo(e1.percentualNaAlocacao));
    ativos = list;
  }

  void limparErrorDialog() {
    errorDialog = null;
  }

  CotacaoModel getCotacao(String papel) {
    return AppCore.getCotacao(papel);
  }

  void setCarteira(String carteiraId) {
    _carteira = AppCore.getCarteira(carteiraId);
  }

  String get title => _carteira.descricao;

  CarteiraDTO get carteira => _carteira;

  void dispose() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }
  }
}
