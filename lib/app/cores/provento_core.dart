import 'package:alloc/app/cores/ativo_core.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/provento_dto.dart';
import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/evento_provento.dart';
import 'package:alloc/app/shared/models/provento_model.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/services/provento_service.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProventoCore {
  IProventoService _proventoService;
  IEventService _eventService;
  List<ProventoModel> _proventos;
  AtivoCore _ativoCore;
  UsuarioModel _usuario;

  ProventoCore._(UsuarioModel usuario, AtivoCore ativoCore) {
    if (usuario == null || ativoCore == null)
      throw new ApplicationException("Instancias obrigatórias não informadas (Provento)!");
    _usuario = usuario;
    _ativoCore = ativoCore;
    _proventoService = Modular.get<ProventoService>();
    _eventService = Modular.get<EventService>();
  }

  static Future<ProventoCore> initInstance(UsuarioModel usuario, AtivoCore ativoCore) async {
    ProventoCore proventoCore = new ProventoCore._(usuario, ativoCore);
    await proventoCore._loadProventosPendentesLancar();
    return proventoCore;
  }

  Future<void> _loadProventosPendentesLancar() async {
    DateTime primeiroDiaDoMes = DateUtil.getPrimeiraDataHoraDoMesByDate(DateTime.now());
    List<ProventoModel> proventos =
        await _proventoService.findProventos(primeiroDiaDoMes, onlyCache: true);
    _proventos = _extrairApenasProventosDeAtivosExistentes(proventos);
  }

  List<ProventoModel> _extrairApenasProventosDeAtivosExistentes(List<ProventoModel> proventos) {
    List<ProventoModel> result = [];
    List<AtivoDTO> ativos = _ativoCore.allAtivos;

    for (ProventoModel provento in proventos) {
      for (AtivoDTO ativo in ativos) {
        if (ativo.papel == provento.papel) {
          result.add(provento);
          break;
        }
      }
    }

    return result;
  }

  Future<List<ProventoDTO>> getProventosNaoLancadosByCarteira(String idCarteira) async {
    List<ProventoDTO> result = [];

    if (this._proventos.isEmpty) return result;

    List<ProventoDTO> _proventos = _extrairApenasProventosDeAtivosDaCarteira(idCarteira);
    List<EventoProvento> events = await _getEventosDeProventosDoMesByCarteira(idCarteira);

    for (ProventoDTO provento in _proventos) {
      if (!_existeEventoLancadoDoProvento(events, provento)) {
        result.add(provento);
      }
    }

    return result;
  }

  Future<List<EventoProvento>> _getEventosDeProventosDoMesByCarteira(String idCarteira) async {
    DateTime inicio = DateUtil.getPrimeiraDataHoraDoMesByDate(DateTime.now());
    DateTime fim = DateTime.now();

    List<EventoProvento> events = List<EventoProvento>.from(
        await _eventService.getEventsByCarteiraAndPeriodoAndTipo(
            _usuario.id, idCarteira, inicio, fim, TipoEvento.PROVENTO));

    return events;
  }

  List<ProventoDTO> _extrairApenasProventosDeAtivosDaCarteira(String idCarteira) {
    List<ProventoDTO> result = [];
    List<AtivoDTO> ativosCarteira = _ativoCore.getAtivosByCarteira(idCarteira);

    for (ProventoModel provento in _proventos) {
      for (AtivoDTO ativo in ativosCarteira) {
        if (ativo.papel == provento.papel) {
          ProventoDTO dto = new ProventoDTO(provento, ativo.qtd.toInt());
          result.add(dto);
          break;
        }
      }
    }
    return result;
  }

  bool _existeEventoLancadoDoProvento(List<EventoProvento> events, ProventoDTO provento) {
    for (EventoProvento evento in events) {
      if (evento.idProvento == provento.id) {
        return true;
      }
    }
    return false;
  }

  List<ProventoModel> get proventos => this._proventos;
}
