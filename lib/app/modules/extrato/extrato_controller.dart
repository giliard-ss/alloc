import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/extrato/dtos/extrato_resumo_dto.dart';
import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/models/evento_venda_renda_variavel.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'extrato_controller.g.dart';

@Injectable()
class ExtratoController = _ExtratoControllerBase with _$ExtratoController;

abstract class _ExtratoControllerBase with Store {
  IEventService _eventService = Modular.get<EventService>();
  CarteiraController _carteiraController = Modular.get<CarteiraController>();
  ReactionDisposer _carteirasReactDispose;
  @observable
  List<AbstractEvent> events = [];
  @observable
  DateTime _mesAno;
  @observable
  List<ExtratoResumoDTO> resumo;
  TipoEvento tipoEvento;

  Future<void> init() async {
    try {
      _mesAno = DateTime.now();
      await _loadEvents();
      _startCarteirasReaction();
    } catch (e, stacktrace) {
      LoggerUtil.error(e);
    }
  }

  Future<void> _loadEvents() async {
    List<AbstractEvent> events = await getUltimosByQtdDias();
    events.sort((AbstractEvent a, AbstractEvent b) => b.getData().compareTo(a.getData()));

    resumo = _createResumoByEvents(events);
    this.events = events;
  }

  List<ExtratoResumoDTO> _createResumoByEvents(List<AbstractEvent> events) {
    Map resumo = new Map();

    events.forEach((AbstractEvent i) {
      if (!resumo.containsKey(i.getTipoEvento())) {
        resumo[i.getTipoEvento()] = 0;
      }
      resumo[i.getTipoEvento()] = resumo[i.getTipoEvento()] + i.getValor();
    });
    return resumo.entries
        .map((entry) => ExtratoResumoDTO(entry.key, entry.value, TipoEvento(entry.key)))
        .toList();
  }

  Future<List<AbstractEvent>> getUltimosByQtdDias() async {
    if (mesAno == null) _mesAno = DateTime.now();
    DateTime inicio = DateUtil.getPrimeiraDataHoraDoMesByDate(_mesAno);
    DateTime fim = DateUtil.getUltimaDataHoraDoMesByDate(_mesAno);

    if (tipoEvento == null)
      return await _eventService.getEventsByCarteiraAndPeriodo(
          AppCore.usuario.id, _carteiraController.carteira.id, inicio, fim);
    else
      return await _eventService.getEventsByCarteiraAndPeriodoAndTipo(
          AppCore.usuario.id, _carteiraController.carteira.id, inicio, fim, tipoEvento);
  }

  void _startCarteirasReaction() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }

    _carteirasReactDispose = AppCore.createCarteirasReact((e) {
      _loadEvents();
    });
  }

  Future<String> excluir(AbstractEvent event) async {
    try {
      await _eventService.delete(event);
      await AppCore.notifyAddDelEvent();
      return null;
    } on ApplicationException catch (e) {
      return e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir!";
    }
  }

  void editarEvent(AbstractEvent event) {
    if (event.getTipoEvento() == TipoEvento.PROVENTO.code)
      Modular.to.pushNamed("/carteira/provento/${event.getId()}");

    if (event is AplicacaoRendaVariavel || event is VendaRendaVariavelEvent)
      Modular.to.pushNamed("/carteira/ativo/id/${event.getId()}");
  }

  bool isPermiteEdicao(AbstractEvent event) {
    if (event.getTipoEvento() == TipoEvento.PROVENTO.code) return true;
    if (event is AplicacaoRendaVariavel) return true;
    if (event is VendaRendaVariavelEvent) return true;
    return false;
  }

  @action
  void selectMesAno(DateTime value) {
    _mesAno = value;
    events = [];
    _loadEvents();
  }

  @action
  void selectTipoEvento(TipoEvento tipoEvento) {
    if (this.tipoEvento != null && tipoEvento.code == this.tipoEvento.code)
      this.tipoEvento = null;
    else
      this.tipoEvento = tipoEvento;
    _loadEvents();
  }

  get mesAno => _mesAno;

  void dispose() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }
  }
}
