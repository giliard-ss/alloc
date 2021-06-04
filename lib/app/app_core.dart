import 'dart:async';
import 'package:alloc/app/shared/config/backup_vendas.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/models/evento_venda_renda_variavel.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'shared/services/event_service.dart';

class AppCore {
  static ICarteiraService _carteiraService;
  static IAtivoService _ativoService;
  static IAlocacaoService _alocacaoService;
  static IEventService _eventService;
  static String _tableCotacoes = "cotacao";
  static StreamSubscription<DocumentSnapshot> _listenerCotacoes;
  static var _cotacoes = Observable<List<CotacaoModel>>([]);
  static var _ativosDTO = Observable<List<AtivoDTO>>([]);
  static var _carteirasDTO = Observable<List<CarteiraDTO>>([]);
  static var _alocacoesDTO = Observable<List<AlocacaoDTO>>([]);
  static UsuarioModel _usuario;
  static ReactionDisposer _reactionCotacoesDispose;
  static Observable<double> _reactionRefreshCarteira = Observable<double>(0);

  static Future<void> init(UsuarioModel usuario) async {
    _usuario = usuario;
    _carteiraService = Modular.get<CarteiraService>();
    _ativoService = Modular.get<AtivoService>();
    _alocacaoService = Modular.get<AlocacaoService>();
    _eventService = Modular.get<EventService>();

    // List<AbstractEvent> events = BackupVendas.getVendas();

    //for (AbstractEvent e in events) await _eventService.save(e);

    //List<AbstractEvent> events = await _eventService.getEventsByTipoAndCarteira(
    //    _usuario.id, "VENDA", "eyyokB82WciaQB1vf0C4");

    //for (AbstractEvent e in events) await _eventService.delete(e);

    await _startListenerCotacoes();
    await loadAll();
    //await _startListenerCotacoes();
    _startReactionCotacoes();
  }

  static Future<void> loadAll() async {
    await _loadCarteiras();
    await _loadAtivos();
    //await _loadCotacoes();
    //await _startListenerCotacoes();
    _refreshAtivosDTO();
    await _loadAlocacoes();
    _refreshAlocacoesDTO();
    _refreshCarteiraDTO();
  }

  static Future<void> _loadAlocacoes({bool onlyCache = true}) async {
    List<AlocacaoDTO> result = [];
    List<AlocacaoModel> list =
        await _alocacaoService.getAllAlocacoes(_usuario.id, onlyCache: onlyCache);
    list.forEach((a) => result.add(AlocacaoDTO(a)));
    runInAction(() {
      _alocacoesDTO.value = result;
    });
  }

  static void _refreshAtivosDTO() {
    runInAction(() {
      List<AtivoDTO> ativosDTO = [];
      _ativosDTO.value.forEach((e) {
        e.cotacaoModel = getCotacao(e.papel);
        ativosDTO.add(e);
      });
      _ativosDTO.value = ativosDTO;
    });
  }

  static void _refreshAlocacoesDTO() {
    List<AlocacaoDTO> result = [];
    for (AlocacaoDTO aloc in _alocacoesDTO.value) {
      CarteiraDTO carteira = getCarteira(aloc.idCarteira);

      aloc.totalAportado = getTotalAportadoAtivosByAlocacao(aloc.id);
      aloc.totalAportadoAtual = aloc.totalAportado + getRendimentoAtivosByAlocacao(aloc.id);

      double totalAposAporte = carteira.getTotalAposAporte() * _getAlocacaoReal(aloc);

      aloc.totalInvestir = totalAposAporte - aloc.totalAportadoAtual;

      result.add(aloc);
    }
    _alocacoesDTO.value = result;
  }

  //Calcula a porcentagem real levando em conta todos as alocacoes superiores
  // ex: aloc3 * aloc2 * aloc1 = alocacao real
  static double _getAlocacaoReal(AlocacaoDTO aloc) {
    double result = 1;
    AlocacaoDTO prox = aloc;
    while (true) {
      result = result * prox.alocacao.toDouble();
      if (StringUtil.isEmpty(prox.idSuperior)) {
        break;
      } else {
        prox = _alocacoesDTO.value.where((e) => e.id == prox.idSuperior).first;
      }
    }
    return result;
  }

  static Future<void> _loadCarteiras({bool onlyCache = true}) async {
    await runInAction(() async {
      List<CarteiraModel> carteiras =
          await _carteiraService.getCarteiras(_usuario.id, onlyCache: onlyCache);
      List<CarteiraDTO> result = [];
      carteiras.forEach((e) => result.add(CarteiraDTO(e)));
      _carteirasDTO.value = result;
    });
  }

  // static Future<void> _refreshAtivos() async {
  //   await _loadAtivos();
  //   await _loadCotacoes();
  //   _refreshCarteiraDTO();
  // }

  static CotacaoModel getCotacao(String id) {
    for (CotacaoModel cm in _cotacoes.value) {
      if (cm.id == id) {
        cm.variacao = cm.variacao == null ? 0.0 : cm.variacao;
        return cm;
      }
    }

    return CotacaoModel(id, 0, 0);
  }

  static _startReactionCotacoes() {
    if (_reactionCotacoesDispose != null) {
      _reactionCotacoesDispose();
    }
    _reactionCotacoesDispose = _createCotacoesReact((e) {
      ///toda vez que as cotacoes forem atualizadas, os valores da carteiraDTO tambem serao
      _loadAtivos();
      _refreshAtivosDTO();
      _refreshAlocacoesDTO();
      _refreshCarteiraDTO();
    });
  }

  static Future<void> notifyAddDelCarteira() async {
    await _loadCarteiras(onlyCache: false);
    _refreshCarteiraDTO();
  }

  static Future<void> notifyAddDelEvent() async {
    return loadAll();
  }

  static Future<void> notifyAddDelAtivo() async {
    await _loadAtivos(onlyCache: false);
    //await _loadCotacoes();
    _refreshAtivosDTO();
    _refreshAlocacoesDTO();
    _refreshCarteiraDTO();
  }

  static Future<void> notifyAddAtivo(String idAtivo) async {
    await _ativoService.findById(idAtivo, onlyCache: false);
    await _loadAtivos();
    //await _loadCotacoes();
    _refreshAtivosDTO();
    _refreshAlocacoesDTO();
    _refreshCarteiraDTO();
  }

  static Future<void> notifyAddDelAlocacao() async {
    await _loadAlocacoes(onlyCache: false);
    _refreshAlocacoesDTO();
    _refreshCarteiraDTO();
  }

  static Future<void> notifyUpdateAtivo() async {
    await _loadAtivos(onlyCache: false);
    _refreshAtivosDTO();
    _refreshAlocacoesDTO();
    _refreshCarteiraDTO();
  }

  static Future<void> notifyUpdateCarteira() async {
    await _loadCarteiras(onlyCache: false);
    _refreshAlocacoesDTO();
    _refreshCarteiraDTO();
  }

  static Future<void> notifyUpdateAlocacao() async {
    //await _loadAtivos();
    //_refreshAtivosDTO();
    await _loadAlocacoes(onlyCache: false);
    _refreshAlocacoesDTO();
    _refreshCarteiraDTO();
  }

  static void _refreshCarteiraDTO() {
    runInAction(() {
      List<CarteiraDTO> carteiras = [];
      _carteirasDTO.value.forEach((carteira) {
        double totalAportadoAtivos = _getTotalAportadoAtivos(carteira.id);
        double rendimentoAtivos = _getRendimentoAtivos(carteira.id);

        carteira.totalAportado = totalAportadoAtivos;
        carteira.totalAportadoAtual = (totalAportadoAtivos + (rendimentoAtivos));
        carteiras.add(carteira);
      });
      _carteirasDTO.value = carteiras;
      _reactionRefreshCarteira.value = _reactionRefreshCarteira.value + 1;
    });
  }

  static double _getRendimentoAtivos(String idCarteira) {
    double totalAgora = 0;
    double totalAportado = 0;
    _ativosDTO.value.forEach((e) {
      if (e.idCarteira == idCarteira) {
        totalAgora = totalAgora + (e.qtd * getCotacao(e.papel).ultimo.toDouble());
        totalAportado = totalAportado + (e.totalAportado.toDouble());
      }
    });

    return totalAgora - totalAportado;
  }

  static double getRendimentoAtivosByAlocacao(String idAlocacao) {
    double totalAgora = 0;
    double totalAportado = 0;
    _ativosDTO.value.forEach((e) {
      if (e.superiores.contains(idAlocacao)) {
        totalAgora += e.qtd * getCotacao(e.papel).ultimo.toDouble();
        totalAportado += e.totalAportado.toDouble();
      }
    });

    return totalAgora - totalAportado;
  }

  static bool alocacaoPossuiAtivos(String idAlocacao) {
    return _ativosDTO.value.where((e) => e.superiores.contains(idAlocacao)).isNotEmpty;
  }

  ///crie a reacao vinculada a um variavel para que seja possivel chamar o dispose() pra encerrar
  static ReactionDisposer _createCotacoesReact(Function(List<CotacaoModel> cotacoes) fnc) {
    return reaction((_) => _cotacoes.value, fnc);
  }

  ///toda vez que _carteirasDTO sofrer alteracao de valor, executará a função em parametro
  static ReactionDisposer createCarteirasReact(Function(double numReacao) func) {
    return reaction((_) => _reactionRefreshCarteira.value, func);
  }

  static Future<void> _loadAtivos({bool onlyCache = true}) async {
    List<AtivoDTO> ativos = await _getAtivosAtuais();

    ativos = _agruparAtivosPorPapelAndAlocacao(ativos);

    _ajustarPorcentagemDeAlocacaoDosAtivos(ativos);

    runInAction(() {
      _ativosDTO.value = ativos;
    });
  }

  static Future<List<AbstractEvent>> _getEventosAplicacaoAndVendaOrdenado() async {
    List<AbstractEvent> events =
        await _eventService.getEventsByTipo(usuario.id, TipoEvento.APLICACAO.code);
    events.addAll(await _eventService.getEventsByTipo(usuario.id, TipoEvento.VENDA.code));
    events.sort((a, b) => a.getData().compareTo(b.getData()));
    return events;
  }

  static AtivoDTO _convertEventToAtivoDTO(AbstractEvent event) {
    AtivoModel model = AtivoModel.fromAplicacaoRendaVariavel(event);
    CotacaoModel cotacao = getCotacao(model.papel);
    return AtivoDTO(model, cotacao);
  }

  static Future<List<AtivoDTO>> _getAtivosAtuais() async {
    List<AbstractEvent> events = await _getEventosAplicacaoAndVendaOrdenado();
    List<AtivoDTO> ativos = [];

    for (AbstractEvent event in events) {
      if (event is AplicacaoRendaVariavel) {
        AtivoDTO ativoDTO = _convertEventToAtivoDTO(event);
        ativos.add(ativoDTO);
      }

      if (event is VendaRendaVariavelEvent) {
        _excludeAtivosJaVendidos(ativos, event);
      }
    }
    ativos.removeWhere((e) => e.qtd <= 0);
    return ativos;
  }

  static void _excludeAtivosJaVendidos(List<AtivoDTO> ativos, VendaRendaVariavelEvent event) {
    double qtdRemover = event.qtd;

    if (event.papel == "MALL11") {
      print(event);
    }

    for (int i = ativos.length - 1; i >= 0; i--) {
      AtivoDTO a = ativos[i];
      if (a.idCarteira != event.carteiraId) continue;
      if (!_listEquals(a.superiores, event.superiores)) continue;
      if (a.papel != event.papel) continue;

      if (a.qtd >= qtdRemover) {
        a.totalAplicado -= (a.precoMedio * qtdRemover);
        a.qtd -= qtdRemover;

        break;
      } else {
        qtdRemover -= a.qtd;
        a.qtd = 0;
        a.totalAplicado = 0;
      }
    }
  }

  static bool _listEquals(List list1, List list2) {
    if (list1.isEmpty && list2.isEmpty) return true;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  static List<AtivoDTO> _agruparAtivosPorPapelAndAlocacao(List<AtivoDTO> ativos) {
    Map<String, AtivoDTO> temp = {};
    for (AtivoDTO ativo in ativos) {
      String key = _getKeyAtivoByPapelAndAlocacoes(ativo);

      if (temp.containsKey(key)) {
        AtivoDTO ativoTemp = temp[key];
        ativoTemp.totalAplicado += ativo.totalAplicado;
        ativoTemp.qtd += ativo.qtd;
        temp[key] = ativoTemp;
      } else {
        temp[key] = ativo;
      }
    }
    return List<AtivoDTO>.from(GeralUtil.mapToList(temp));
  }

  static List<AtivoDTO> _agruparAtivosPorPapel(List<AtivoDTO> ativos) {
    Map<String, AtivoDTO> temp = {};
    for (AtivoDTO ativo in ativos) {
      String key = ativo.papel;

      if (temp.containsKey(key)) {
        AtivoDTO ativoTemp = temp[key];
        ativoTemp.totalAplicado += ativo.totalAplicado;
        ativoTemp.qtd += ativo.qtd;
        temp[key] = ativoTemp;
      } else {
        temp[key] = ativo;
      }
    }
    return List<AtivoDTO>.from(GeralUtil.mapToList(temp));
  }

  static void _ajustarPorcentagemDeAlocacaoDosAtivos(List<AtivoDTO> ativos) {
    Map<String, int> qtdPapeisPorAlocacao = _getQuantidadePapeisPorAlocacao(ativos);
    for (AtivoDTO ativo in ativos) {
      String alocacao = _getAllAlocacoesString(ativo);
      ativo.alocacao = 1 / qtdPapeisPorAlocacao[alocacao];
    }
  }

  static Map<String, int> _getQuantidadePapeisPorAlocacao(List<AtivoDTO> ativos) {
    Map<String, int> qtdPapeisPorAlocacao = {};
    for (AtivoDTO ativo in ativos) {
      String alocacao = _getAllAlocacoesString(ativo);

      if (qtdPapeisPorAlocacao.containsKey(alocacao)) {
        qtdPapeisPorAlocacao[alocacao] += 1;
      } else {
        qtdPapeisPorAlocacao[alocacao] = 1;
      }
    }
    return qtdPapeisPorAlocacao;
  }

  static String _getKeyAtivoByPapelAndAlocacoes(AtivoDTO ativo) {
    String alocacao = _getAllAlocacoesString(ativo);
    return ativo.papel + alocacao;
  }

  static String _getAllAlocacoesString(AtivoDTO ativo) {
    String key = ativo.idCarteira;
    for (String superior in ativo.superiores) {
      key += superior;
    }
    return key;
  }

  static List<String> _getPapeisAtivos() {
    return List.generate(_ativosDTO.value.length, (i) {
      return _ativosDTO.value[i].papel;
    });
  }

  static List<String> _getPapeisObrigatorios() {
    List<String> list = [];

    if (_ativosDTO.value.where((AtivoDTO e) => e.isAcao || e.isETF).isNotEmpty) {
      list.add("IBOV");
    }

    if (_ativosDTO.value.where((AtivoDTO e) => e.isFII).isNotEmpty) {
      list.add("IFIX");
    }

    return list;
  }

  static double _getTotalAportadoAtivos(String idCarteira) {
    double total = 0;
    _ativosDTO.value.forEach((e) {
      if (e.idCarteira == idCarteira) {
        total += e.totalAportado.toDouble();
      }
    });
    return total;
  }

  static double getTotalAportadoAtivosByAlocacao(String idAlocacao) {
    double total = 0;
    _ativosDTO.value.forEach((e) {
      if (e.superiores.contains(idAlocacao)) {
        total += e.totalAportado.toDouble();
      }
    });
    return total;
  }

  static Future<void> _startListenerCotacoes() async {
    try {
      if (_listenerCotacoes != null) {
        await _stopListenerCotacoes();
      }

      DocumentReference reference =
          FirebaseFirestore.instance.collection(_tableCotacoes).doc("ULTIMO");

      _listenerCotacoes = reference.snapshots().listen((snapshot) async {
        List<CotacaoModel> cotacoes = snapshotToCotacoes(snapshot);
        runInAction(() {
          _cotacoes.value = cotacoes;
        });
      });
      LoggerUtil.info("Listener de cotações iniciado.");
    } catch (ex) {
      throw new ApplicationException('Falha ao iniciar Listener de cotações!', ex);
    }
  }

  static List<CotacaoModel> snapshotToCotacoes(DocumentSnapshot snapshot) {
    List<CotacaoModel> cotacoes = List.generate(snapshot.data()['values'].length, (i) {
      Map mapCotacao = snapshot.data()['values'][i];
      mapCotacao["date"] = snapshot.data()['date'];
      return CotacaoModel.fromMap(mapCotacao);
    });
    return cotacoes;
  }

  static Future<void> _stopListenerCotacoes() async {
    try {
      await _listenerCotacoes.cancel();
      _listenerCotacoes = null;
      LoggerUtil.info("Listener de cotações interrompido.");
    } on Exception catch (ex) {
      throw new ApplicationException('Falha ao interromper Listener de cotações!', ex);
    }
  }

  static CarteiraDTO getCarteira(String carteiraId) {
    for (CarteiraDTO c in _carteirasDTO.value) {
      if (c.id == carteiraId) return c.clone();
    }
    throw new ApplicationException('Carteira $carteiraId não encontrada!');
  }

  static bool alocacaoPossuiSubAlocacao(String idAlocacao) {
    return _alocacoesDTO.value.where((e) => e.idSuperior == idAlocacao).isNotEmpty;
  }

  static List<AlocacaoDTO> getAlocacoesByIdSuperior(String idSuperior) {
    List<AlocacaoDTO> result = [];
    _alocacoesDTO.value
        .where((e) => e.idSuperior == idSuperior)
        .forEach((e) => result.add(e.clone()));
    return result;
  }

  static List<AlocacaoDTO> getAlocacoesByCarteiraId(String carteiraId, [String idSuperior]) {
    List<AlocacaoDTO> result = [];
    _alocacoesDTO.value
        .where((e) => e.idCarteira == carteiraId && e.idSuperior == idSuperior)
        .forEach((e) => result.add(e.clone()));
    return result;
  }

  static AlocacaoDTO getAlocacaoById(String id) {
    return _alocacoesDTO.value.firstWhere((e) => e.id == id).clone();
  }

  static List<CarteiraDTO> get carteiras {
    List<CarteiraDTO> result = [];
    _carteirasDTO.value.forEach((e) => result.add(e.clone()));
    return result;
  }

  static List<AtivoDTO> get allAtivos {
    List<AtivoDTO> result = [];
    double xx = 0.0;
    for (AtivoDTO ab in _ativosDTO.value) {
      if (ab.papel == "MALL11") {
        xx += ab.qtd;
      }
    }

    // List<AtivoDTO> ativosAgrupados = _agruparAtivosPorPapel(_ativosDTO.value);
    _ativosDTO.value.forEach((e) => result.add(e.clone()));
    return result;
  }

  static List<String> get allPapeis {
    List<String> result = [];
    _cotacoes.value.forEach((e) => result.add(e.id));
    return result;
  }

  static List<AtivoDTO> getAtivosByCarteira(String idCarteira) {
    List<AtivoDTO> result = [];
    _ativosDTO.value
        .where(
          (e) => e.idCarteira == idCarteira,
        )
        .forEach((e) => result.add(e.clone()));
    return result;
  }

  static bool existsAtivosNaCarteira(String idCarteira) {
    return _ativosDTO.value
        .where(
          (e) => e.idCarteira == idCarteira,
        )
        .isNotEmpty;
  }

  static List<AtivoModel> getAtivosModelByCarteira(String idCarteira) {
    List<AtivoModel> result = [];
    _ativosDTO.value
        .where(
          (e) => e.idCarteira == idCarteira,
        )
        .forEach((e) => result.add(AtivoModel.fromMap(e.toMap())));
    return result;
  }

  static List<AtivoDTO> getAtivosByIdSuperior(String superiorId) {
    List<AtivoDTO> result = [];
    _ativosDTO.value
        .where(
          (e) => StringUtil.isEmpty(superiorId)
              ? e.superiores.isEmpty
              : e.superiores.contains(superiorId),
        )
        .forEach((e) => result.add(e.clone()));
    return result;
  }

  static AtivoDTO getAtivo(String carteiraId, String superiorId, String papel) {
    AtivoDTO ativo = _ativosDTO.value.firstWhere(
        (e) =>
            (StringUtil.isEmpty(superiorId)
                ? e.superiores.isEmpty
                : e.superiores.contains(superiorId)) &&
            e.idCarteira == carteiraId &&
            e.papel == papel,
        orElse: null);

    if (ativo == null) throw new ApplicationException("Ativo não encontrado!");

    return ativo.clone();
  }

  static List<AtivoModel> getAtivosModelByIdSuperior(String superiorId) {
    List<AtivoModel> result = [];
    _ativosDTO.value
        .where(
          (e) => StringUtil.isEmpty(superiorId)
              ? e.superiores.isEmpty
              : e.superiores.contains(superiorId),
        )
        .forEach((e) => result.add(AtivoModel.fromMap(e.toMap())));
    return result;
  }

  static UsuarioModel get usuario => _usuario;
}
