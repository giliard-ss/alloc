import 'dart:async';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/services/preference_service.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class AppCore {
  static ICarteiraService _carteiraService;
  static IAtivoService _ativoService;
  static IAlocacaoService _alocacaoService;
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
    await _loadCarteiras();
    await _loadAtivos();
    //await _loadCotacoes();
    await _startListenerCotacoes();
    _refreshAtivosDTO();
    await _loadAlocacoes();
    _refreshAlocacoesDTO();
    _refreshCarteiraDTO();
    //await _startListenerCotacoes();
    _startReactionCotacoes();
  }

  static Future<void> _loadAlocacoes({bool onlyCache = true}) async {
    List<AlocacaoDTO> result = [];
    List<AlocacaoModel> list = await _alocacaoService
        .getAllAlocacoes(_usuario.id, onlyCache: onlyCache);
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
      aloc.totalAportadoAtual =
          aloc.totalAportado + getRendimentoAtivosByAlocacao(aloc.id);

      double totalAposAporte =
          carteira.getTotalAposAporte() * _getAlocacaoReal(aloc);

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
      List<CarteiraModel> carteiras = await _carteiraService
          .getCarteiras(_usuario.id, onlyCache: onlyCache);
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
      _refreshAtivosDTO();
      _refreshAlocacoesDTO();
      _refreshCarteiraDTO();
    });
  }

  static Future<void> notifyAddDelCarteira() async {
    await _loadCarteiras(onlyCache: false);
    _refreshCarteiraDTO();
  }

  static Future<void> notifyAddDelAtivo() async {
    await _loadAtivos(onlyCache: false);
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
        carteira.totalAportadoAtual =
            (totalAportadoAtivos + (rendimentoAtivos));
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
        totalAgora =
            totalAgora + (e.qtd * getCotacao(e.papel).ultimo.toDouble());
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
    return _ativosDTO.value
        .where((e) => e.superiores.contains(idAlocacao))
        .isNotEmpty;
  }

  ///crie a reacao vinculada a um variavel para que seja possivel chamar o dispose() pra encerrar
  static ReactionDisposer _createCotacoesReact(
      Function(List<CotacaoModel> cotacoes) fnc) {
    return reaction((_) => _cotacoes.value, fnc);
  }

  ///toda vez que _carteirasDTO sofrer alteracao de valor, executará a função em parametro
  static ReactionDisposer createCarteirasReact(
      Function(double numReacao) func) {
    return reaction((_) => _reactionRefreshCarteira.value, func);
  }

  static Future<void> _loadAtivos({bool onlyCache = true}) async {
    List<AtivoDTO> result = [];
    List<AtivoModel> ativos =
        await _ativoService.getAtivos(_usuario.id, onlyCache: onlyCache);
    ativos.forEach((e) {
      result.add(AtivoDTO(e, getCotacao(e.papel)));
    });

    runInAction(() {
      _ativosDTO.value = result;
    });
  }

  static List<String> _getPapeisAtivos() {
    return List.generate(_ativosDTO.value.length, (i) {
      return _ativosDTO.value[i].papel;
    });
  }

  static List<String> _getPapeisObrigatorios() {
    List<String> list = [];

    if (_ativosDTO.value
        .where((AtivoDTO e) => e.isAcao || e.isETF)
        .isNotEmpty) {
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
        // if (snapshot.docChanges
        //     .where((e) => e.doc.id == "cotacao")
        //     .isNotEmpty) {
        //   _loadCotacoes();
        // }
        //print(snapshot.docChanges.length);
        List<CotacaoModel> cotacoesChange =
            List.generate(snapshot.data()['values'].length, (i) {
          return CotacaoModel.fromMap(snapshot.data()['values'][i]);
        });

        await _refreshCotacoes(cotacoesChange);
      });
      LoggerUtil.info("Listener de cotações iniciado.");
    } catch (ex) {
      throw new ApplicationException(
          'Falha ao iniciar Listener de cotações!', ex);
    }
  }

  static Future<List<CotacaoModel>> mergeCotacoes(
      List<CotacaoModel> cotacoesChanged) async {
    List<CotacaoModel> list = [];
    //pega a cotacao atualizada e se nem todas foram atualizadas, pega a existente
    _cotacoes.value.forEach((existente) {
      CotacaoModel atualizada = cotacoesChanged.firstWhere(
          (atualizada) => atualizada.id == existente.id,
          orElse: () => null);

      if (atualizada != null) {
        list.add(atualizada);
      } else {
        list.add(existente);
      }
    });

    return list;
  }

  static Future<void> _refreshCotacoes(
      List<CotacaoModel> cotacoesChange) async {
    List<CotacaoModel> list = [];

    if (_cotacoes.value.isNotEmpty) {
      list = await mergeCotacoes(cotacoesChange);
    } else {
      list = cotacoesChange;
    }

    runInAction(() {
      _cotacoes.value = list;
    });
  }

  // static Future<void> _loadCotacoes() async {
  //   List<String> papeis = _getPapeisAtivos();
  //   papeis.addAll(_getPapeisObrigatorios());
  //   if (papeis.isEmpty) {
  //     return;
  //   }

  //   QuerySnapshot query = await FirebaseFirestore.instance
  //       .collection(_tableCotacoes)
  //       //.where( )
  //       .get();

  //   List<CotacaoModel> cotacoes = List.generate(query.docs.length, (i) {
  //     return CotacaoModel.fromMap(query.docs[i].data());
  //   });

  //   runInAction(() async {
  //     _cotacoes.value = cotacoes;
  //   });
  // }

  static Future<void> _stopListenerCotacoes() async {
    try {
      await _listenerCotacoes.cancel();
      _listenerCotacoes = null;
      LoggerUtil.info("Listener de cotações interrompido.");
    } on Exception catch (ex) {
      throw new ApplicationException(
          'Falha ao interromper Listener de cotações!', ex);
    }
  }

  static CarteiraDTO getCarteira(String carteiraId) {
    for (CarteiraDTO c in _carteirasDTO.value) {
      if (c.id == carteiraId) return c.clone();
    }
    throw new ApplicationException('Carteira $carteiraId não encontrada!');
  }

  static bool alocacaoPossuiSubAlocacao(String idAlocacao) {
    return _alocacoesDTO.value
        .where((e) => e.idSuperior == idAlocacao)
        .isNotEmpty;
  }

  static List<AlocacaoDTO> getAlocacoesByIdSuperior(String idSuperior) {
    List<AlocacaoDTO> result = [];
    _alocacoesDTO.value
        .where((e) => e.idSuperior == idSuperior)
        .forEach((e) => result.add(e.clone()));
    return result;
  }

  static List<AlocacaoDTO> getAlocacoesByCarteiraId(String carteiraId,
      [String idSuperior]) {
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
