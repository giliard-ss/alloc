import 'dart:async';
import 'package:alloc/app/cores/alocacao_core.dart';
import 'package:alloc/app/cores/ativo_core.dart';
import 'package:alloc/app/cores/carteira_core.dart';
import 'package:alloc/app/cores/cotacao_core.dart';
import 'package:alloc/app/cores/provento_core.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/models/provento_model.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/utils/exception_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';

import 'package:mobx/mobx.dart';

class AppCore {
  static UsuarioModel _usuario;
  static CarteiraCore _carteiraCore;
  static CotacaoCore _cotacaoCore;
  static AtivoCore _ativoCore;
  static AlocacaoCore _alocacaoCore;
  static ProventoCore _proventoCore;

  static Future<void> init(UsuarioModel usuario) async {
    try {
      _usuario = usuario;
      _cotacaoCore = await CotacaoCore.initInstance();
      _ativoCore = await AtivoCore.initInstance(usuario, _cotacaoCore);
      _carteiraCore = await CarteiraCore.initInstance(usuario, _ativoCore);
      _alocacaoCore = await AlocacaoCore.initInstance(usuario, _carteiraCore, _ativoCore);
      _proventoCore = await ProventoCore.initInstance(usuario, _ativoCore);
      _startReactionCotacoes();
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  static double getRendimentoAtivosByAlocacao(String idAlocacao) {
    return _ativoCore.getRendimentoAtivosByAlocacao(idAlocacao);
  }

  static void _startReactionCotacoes() {
    _cotacaoCore.startReactionCotacoes((e) {
      ///toda vez que as cotacoes forem atualizadas, os valores da carteiraDTO tambem serao
      _ativoCore.loadAtivos();
      _alocacaoCore.refreshAlocacoesDTO();
      _carteiraCore.refreshCarteiraDTO();
    });
  }

  static Future<void> _loadAll() async {
    await _carteiraCore.loadCarteiras();
    await _ativoCore.loadAtivos();
    await _alocacaoCore.loadAlocacoes();
    _alocacaoCore.refreshAlocacoesDTO();
    _carteiraCore.refreshCarteiraDTO();
  }

  static CotacaoModel getCotacao(String id) {
    return _cotacaoCore.getCotacao(id);
  }

  static List<CotacaoModel> get allCotacoes {
    return _cotacaoCore.allCotacoes;
  }

  static Future<void> notifyAddDelCarteira() async {
    await _carteiraCore.loadCarteiras(onlyCache: false);
    _carteiraCore.refreshCarteiraDTO();
  }

  static Future<void> notifyAddDelEvent() async {
    return _loadAll();
  }

  static Future<void> notifyAddDelAtivo() async {
    await _ativoCore.loadAtivos(onlyCache: false);
    //await _loadCotacoes();
    _alocacaoCore.refreshAlocacoesDTO();
    _carteiraCore.refreshCarteiraDTO();
  }

  static Future<void> notifyAddAtivo(String idAtivo) async {
    await _ativoCore.findAtivoById(idAtivo, onlyCache: false);
    await _ativoCore.loadAtivos();
    //await _loadCotacoes();
    _alocacaoCore.refreshAlocacoesDTO();
    _carteiraCore.refreshCarteiraDTO();
  }

  static Future<void> notifyAddDelProvento() async {
    await _carteiraCore.loadCarteiras(onlyCache: true);
    _alocacaoCore.refreshAlocacoesDTO();
    _carteiraCore.refreshCarteiraDTO();
  }

  static Future<void> notifyAddDelAlocacao() async {
    await _alocacaoCore.loadAlocacoes(onlyCache: false);
    _alocacaoCore.refreshAlocacoesDTO();
    _carteiraCore.refreshCarteiraDTO();
  }

  static Future<void> notifyUpdateAtivo() async {
    await _ativoCore.loadAtivos(onlyCache: false);
    _alocacaoCore.refreshAlocacoesDTO();
    _carteiraCore.refreshCarteiraDTO();
  }

  static Future<void> notifyUpdateCarteira() async {
    await _carteiraCore.loadCarteiras(onlyCache: false);
    _alocacaoCore.refreshAlocacoesDTO();
    _carteiraCore.refreshCarteiraDTO();
  }

  static Future<void> notifyUpdateAlocacao() async {
    //await _loadAtivos();
    //_refreshAtivosDTO();
    await _alocacaoCore.loadAlocacoes(onlyCache: false);
    _alocacaoCore.refreshAlocacoesDTO();
    _carteiraCore.refreshCarteiraDTO();
  }

  static bool alocacaoPossuiAtivos(String idAlocacao) {
    return _ativoCore.alocacaoPossuiAtivos(idAlocacao);
  }

  ///toda vez que _carteirasDTO sofrer alteracao de valor, executará a função em parametro
  static ReactionDisposer createCarteirasReact(Function(double numReacao) func) {
    return _carteiraCore.createCarteirasReact(func);
  }

  static double getTotalAportadoAtivosByAlocacao(String idAlocacao) {
    return _ativoCore.getTotalAportadoAtivosByAlocacao(idAlocacao);
  }

  static CarteiraDTO getCarteira(String carteiraId) {
    return _carteiraCore.getCarteira(carteiraId);
  }

  static bool alocacaoPossuiSubAlocacao(String idAlocacao) {
    return _alocacaoCore.alocacaoPossuiSubAlocacao(idAlocacao);
  }

  static List<AlocacaoDTO> getAlocacoesByIdSuperior(String idSuperior) {
    return _alocacaoCore.getAlocacoesByIdSuperior(idSuperior);
  }

  static List<AlocacaoDTO> getAlocacoesByCarteiraId(String carteiraId, [String idSuperior]) {
    return _alocacaoCore.getAlocacoesByCarteiraId(carteiraId, idSuperior);
  }

  static AlocacaoDTO getAlocacaoById(String id) {
    return _alocacaoCore.getAlocacaoById(id);
  }

  static List<CarteiraDTO> get carteiras {
    return _carteiraCore.carteiras;
  }

  static List<AtivoDTO> get allAtivos {
    return _ativoCore.allAtivos;
  }

  static List<String> get allPapeis {
    return _cotacaoCore.allPapeis;
  }

  static List<AtivoDTO> getAtivosByCarteira(String idCarteira) {
    return _ativoCore.getAtivosByCarteira(idCarteira);
  }

  static bool existsAtivosNaCarteira(String idCarteira) {
    return _ativoCore.existsAtivosNaCarteira(idCarteira);
  }

  static List<AtivoModel> getAtivosModelByCarteira(String idCarteira) {
    return _ativoCore.getAtivosModelByCarteira(idCarteira);
  }

  static List<AtivoDTO> getAtivosByIdSuperior(String superiorId) {
    return _ativoCore.getAtivosByIdSuperior(superiorId);
  }

  static AtivoDTO getAtivo(String carteiraId, String superiorId, String papel) {
    return _ativoCore.getAtivo(carteiraId, superiorId, papel);
  }

  static List<AtivoModel> getAtivosModelByIdSuperior(String superiorId) {
    return _ativoCore.getAtivosModelByIdSuperior(superiorId);
  }

  static Future<List<ProventoModel>> getProventosNaoLancadosByCarteira(String idCarteira) {
    return _proventoCore.getProventosNaoLancadosByCarteira(idCarteira);
  }

  static UsuarioModel get usuario => _usuario;
}
