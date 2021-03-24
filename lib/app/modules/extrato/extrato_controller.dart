import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'extrato_controller.g.dart';

@Injectable()
class ExtratoController = _ExtratoControllerBase with _$ExtratoController;

abstract class _ExtratoControllerBase with Store {
  IEventService _eventService = Modular.get<EventService>();

  @observable
  List<AbstractEvent> events = [];

  Future<void> init() async {
    try {
      await _loadEvents();
    } catch (e, stacktrace) {
      print(stacktrace);
      LoggerUtil.error(e);
    }
  }

  Future<void> _loadEvents() async {
    List<AbstractEvent> list = await _eventService.getAllEvents(AppCore.usuario.id);
    list.sort((AbstractEvent a, AbstractEvent b) => b.getData().compareTo(a.getData()));
    events = list;
  }
}
