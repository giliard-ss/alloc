import 'package:alloc/app/cores/cotacao_core.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/models/evento_venda_renda_variavel.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class AtivoCore {
  IAtivoService _ativoService;
  IEventService _eventService;
  var _ativosDTO = Observable<List<AtivoDTO>>([]);
  UsuarioModel _usuario;
  CotacaoCore _cotacaoCore;

  AtivoCore._(UsuarioModel usuario, CotacaoCore cotacaoCore) {
    if (usuario == null || cotacaoCore == null)
      throw new ApplicationException("Instancias obrigatórias não informadas (Ativo)!");

    _usuario = usuario;
    _cotacaoCore = cotacaoCore;
    _ativoService = Modular.get<AtivoService>();
    _eventService = Modular.get<EventService>();
  }

  static Future<AtivoCore> initInstance(UsuarioModel usuario, CotacaoCore cotacaoCore) async {
    AtivoCore ativoCore = new AtivoCore._(usuario, cotacaoCore);
    await ativoCore.loadAtivos();
    return ativoCore;
  }

  Future<void> loadAtivos({bool onlyCache = true}) async {
    List<AtivoDTO> ativos = await _getAtivosAtuais();

    ativos = _agruparAtivosPorPapelAndAlocacao(ativos);

    _ajustarPorcentagemDeAlocacaoDosAtivos(ativos);

    runInAction(() {
      _ativosDTO.value = ativos;
    });

    _refreshAtivosDTO();
  }

  void _refreshAtivosDTO() {
    runInAction(() {
      List<AtivoDTO> ativosDTO = [];
      _ativosDTO.value.forEach((e) {
        e.cotacaoModel = _cotacaoCore.getCotacao(e.papel);
        ativosDTO.add(e);
      });
      _ativosDTO.value = ativosDTO;
    });
  }

  Future<AtivoModel> findAtivoById(String idAtivo, {bool onlyCache = true}) {
    return _ativoService.findById(idAtivo, onlyCache: onlyCache);
  }

  double getRendimentoAtivos(String idCarteira) {
    double totalAgora = 0;
    double totalAportado = 0;
    _ativosDTO.value.forEach((e) {
      if (e.idCarteira == idCarteira) {
        totalAgora = totalAgora + (e.qtd * _cotacaoCore.getCotacao(e.papel).ultimo.toDouble());
        totalAportado = totalAportado + (e.totalAportado.toDouble());
      }
    });

    return totalAgora - totalAportado;
  }

  double getRendimentoAtivosByAlocacao(String idAlocacao) {
    double totalAgora = 0;
    double totalAportado = 0;
    _ativosDTO.value.forEach((e) {
      if (e.superiores.contains(idAlocacao)) {
        totalAgora += e.qtd * _cotacaoCore.getCotacao(e.papel).ultimo.toDouble();
        totalAportado += e.totalAportado.toDouble();
      }
    });

    return totalAgora - totalAportado;
  }

  Observable<List<AtivoDTO>> getAtivosDTO() {
    return _ativosDTO;
  }

  bool alocacaoPossuiAtivos(String idAlocacao) {
    return _ativosDTO.value.where((e) => e.superiores.contains(idAlocacao)).isNotEmpty;
  }

  List<AtivoDTO> _agruparAtivosPorPapelAndAlocacao(List<AtivoDTO> ativos) {
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

  List<AtivoDTO> _agruparAtivosPorPapel(List<AtivoDTO> ativos) {
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

  void _ajustarPorcentagemDeAlocacaoDosAtivos(List<AtivoDTO> ativos) {
    Map<String, int> qtdPapeisPorAlocacao = _getQuantidadePapeisPorAlocacao(ativos);
    for (AtivoDTO ativo in ativos) {
      String alocacao = _getAllAlocacoesString(ativo);
      ativo.alocacao = 1 / qtdPapeisPorAlocacao[alocacao];
    }
  }

  String _getKeyAtivoByPapelAndAlocacoes(AtivoDTO ativo) {
    String alocacao = _getAllAlocacoesString(ativo);
    return ativo.papel + alocacao;
  }

  List<String> _getPapeisAtivos() {
    return List.generate(_ativosDTO.value.length, (i) {
      return _ativosDTO.value[i].papel;
    });
  }

  List<String> _getPapeisObrigatorios() {
    List<String> list = [];

    if (_ativosDTO.value.where((AtivoDTO e) => e.isAcao || e.isETF).isNotEmpty) {
      list.add("IBOV");
    }

    if (_ativosDTO.value.where((AtivoDTO e) => e.isFII).isNotEmpty) {
      list.add("IFIX");
    }

    return list;
  }

  double getTotalAportadoAtivos(String idCarteira) {
    double total = 0;
    _ativosDTO.value.forEach((e) {
      if (e.idCarteira == idCarteira) {
        total += e.totalAportado.toDouble();
      }
    });
    return total;
  }

  double getTotalAportadoAtivosByAlocacao(String idAlocacao) {
    double total = 0;
    _ativosDTO.value.forEach((e) {
      if (e.superiores.contains(idAlocacao)) {
        total += e.totalAportado.toDouble();
      }
    });
    return total;
  }

  List<AtivoDTO> get allAtivos {
    List<AtivoDTO> result = [];
    // List<AtivoDTO> ativosAgrupados = _agruparAtivosPorPapel(_ativosDTO.value);
    _ativosDTO.value.forEach((e) => result.add(e.clone()));
    return result;
  }

  List<AtivoDTO> getAtivosByCarteira(String idCarteira) {
    List<AtivoDTO> result = [];
    _ativosDTO.value
        .where(
          (e) => e.idCarteira == idCarteira,
        )
        .forEach((e) => result.add(e.clone()));
    return result;
  }

  bool existsAtivosNaCarteira(String idCarteira) {
    return _ativosDTO.value
        .where(
          (e) => e.idCarteira == idCarteira,
        )
        .isNotEmpty;
  }

  List<AtivoModel> getAtivosModelByCarteira(String idCarteira) {
    List<AtivoModel> result = [];
    _ativosDTO.value
        .where(
          (e) => e.idCarteira == idCarteira,
        )
        .forEach((e) => result.add(AtivoModel.fromMap(e.toMap())));
    return result;
  }

  List<AtivoDTO> getAtivosByIdSuperior(String superiorId) {
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

  AtivoDTO getAtivo(String carteiraId, String superiorId, String papel) {
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

  List<AtivoModel> getAtivosModelByIdSuperior(String superiorId) {
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

  Future<List<AtivoDTO>> _getAtivosAtuais() async {
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

  AtivoDTO _convertEventToAtivoDTO(AbstractEvent event) {
    AtivoModel model = AtivoModel.fromAplicacaoRendaVariavel(event);
    CotacaoModel cotacao = _cotacaoCore.getCotacao(model.papel);
    return AtivoDTO(model, cotacao);
  }

  void _excludeAtivosJaVendidos(List<AtivoDTO> ativos, VendaRendaVariavelEvent event) {
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

  bool _listEquals(List list1, List list2) {
    if (list1.isEmpty && list2.isEmpty) return true;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  Map<String, int> _getQuantidadePapeisPorAlocacao(List<AtivoDTO> ativos) {
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

  String _getAllAlocacoesString(AtivoDTO ativo) {
    String key = ativo.idCarteira;
    for (String superior in ativo.superiores) {
      key += superior;
    }
    return key;
  }

  Future<List<AbstractEvent>> _getEventosAplicacaoAndVendaOrdenado() async {
    List<AbstractEvent> events =
        await _eventService.getEventsByTipo(_usuario.id, TipoEvento.APLICACAO.code);
    events.addAll(await _eventService.getEventsByTipo(_usuario.id, TipoEvento.VENDA.code));
    events.sort((a, b) => a.getData().compareTo(b.getData()));
    return events;
  }
}
