import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/services/event_service.dart';
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
  List<int> qtdDiasOpcoes = [7, 15, 90];

  Future<void> init() async {
    try {
      await _loadEvents();
      _startCarteirasReaction();
    } catch (e, stacktrace) {
      print(stacktrace);
      LoggerUtil.error(e);
    }
  }

  Future<void> _loadEvents() async {
    if (!AppCore.existsAtivosNaCarteira(_carteiraController.carteira.id)) {
      events = [];
      return;
    }

    List<AbstractEvent> list = await getUltimosByQtdDias(qtdDiasOpcoes[0]);

    if (list.isEmpty) list = await getUltimosByQtdDias(qtdDiasOpcoes[1]);
    if (list.isEmpty) list = await getUltimosByQtdDias(qtdDiasOpcoes[2]);
    list.sort((AbstractEvent a, AbstractEvent b) => b.getData().compareTo(a.getData()));
    events = list;
  }

  Future<List<AbstractEvent>> getUltimosByQtdDias(int qtdDias) async {
    DateTime inicio = DateTime.now().subtract(Duration(days: qtdDias));
    DateTime fim = DateTime.now();
    return await _eventService.getEventsByCarteiraAndPeriodo(
        AppCore.usuario.id, _carteiraController.carteira.id, inicio, fim);
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
      await AppCore.notifyAddDelAtivo();
      return null;
    } on ApplicationException catch (e) {
      return e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      return "Falha ao exlcuir!";
    }
  }
}
