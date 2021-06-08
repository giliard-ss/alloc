import 'package:alloc/app/cores/carteira_core.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'ativo_core.dart';

class AlocacaoCore {
  IAlocacaoService _alocacaoService;
  var _alocacoesDTO = Observable<List<AlocacaoDTO>>([]);
  UsuarioModel _usuario;
  AtivoCore _ativoCore;
  CarteiraCore _carteiraCore;

  AlocacaoCore._(UsuarioModel usuario, CarteiraCore carteiraCore, AtivoCore ativoCore) {
    if (usuario == null || ativoCore == null || carteiraCore == null)
      throw new ApplicationException("Instancias obrigatórias não informadas (Alocação)!");
    _usuario = usuario;
    _carteiraCore = carteiraCore;
    _ativoCore = ativoCore;
    _alocacaoService = Modular.get<AlocacaoService>();
  }

  static Future<AlocacaoCore> initInstance(
      UsuarioModel usuario, CarteiraCore carteiraCore, AtivoCore ativoCore) async {
    AlocacaoCore alocacaoCore = new AlocacaoCore._(usuario, carteiraCore, ativoCore);
    await alocacaoCore.loadAlocacoes();
    alocacaoCore.refreshAlocacoesDTO();
    carteiraCore.refreshCarteiraDTO();
    return alocacaoCore;
  }

  Future<void> loadAlocacoes({bool onlyCache = true}) async {
    List<AlocacaoDTO> result = [];
    List<AlocacaoModel> list =
        await _alocacaoService.getAllAlocacoes(_usuario.id, onlyCache: onlyCache);
    list.forEach((a) => result.add(AlocacaoDTO(a)));
    runInAction(() {
      _alocacoesDTO.value = result;
    });
  }

  void refreshAlocacoesDTO() {
    List<AlocacaoDTO> result = [];
    for (AlocacaoDTO aloc in _alocacoesDTO.value) {
      CarteiraDTO carteira = _carteiraCore.getCarteira(aloc.idCarteira);

      aloc.totalAportado = _ativoCore.getTotalAportadoAtivosByAlocacao(aloc.id);
      aloc.totalAportadoAtual =
          aloc.totalAportado + _ativoCore.getRendimentoAtivosByAlocacao(aloc.id);
      double totalAposAporte = carteira.getTotalAposAporte() * _getAlocacaoReal(aloc);
      aloc.totalInvestir = totalAposAporte - aloc.totalAportadoAtual;
      result.add(aloc);
    }
    _alocacoesDTO.value = result;
  }

  //Calcula a porcentagem real levando em conta todos as alocacoes superiores
  // ex: aloc3 * aloc2 * aloc1 = alocacao real
  double _getAlocacaoReal(AlocacaoDTO aloc) {
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

  bool alocacaoPossuiSubAlocacao(String idAlocacao) {
    return _alocacoesDTO.value.where((e) => e.idSuperior == idAlocacao).isNotEmpty;
  }

  List<AlocacaoDTO> getAlocacoesByIdSuperior(String idSuperior) {
    List<AlocacaoDTO> result = [];
    _alocacoesDTO.value
        .where((e) => e.idSuperior == idSuperior)
        .forEach((e) => result.add(e.clone()));
    return result;
  }

  List<AlocacaoDTO> getAlocacoesByCarteiraId(String carteiraId, [String idSuperior]) {
    List<AlocacaoDTO> result = [];
    _alocacoesDTO.value
        .where((e) => e.idCarteira == carteiraId && e.idSuperior == idSuperior)
        .forEach((e) => result.add(e.clone()));
    return result;
  }

  AlocacaoDTO getAlocacaoById(String id) {
    return _alocacoesDTO.value.firstWhere((e) => e.id == id).clone();
  }
}
