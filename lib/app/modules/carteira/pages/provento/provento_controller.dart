import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/dtos/provento_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/evento_provento.dart';
import 'package:alloc/app/shared/models/provento_model.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'provento_controller.g.dart';

@Injectable()
class ProventoController = _ProventoControllerBase with _$ProventoController;

abstract class _ProventoControllerBase with Store {
  CarteiraController _carteiraController = Modular.get();
  IEventService _eventService = Modular.get<EventService>();

  @observable
  List<ProventoDTO> proventos = [];

  Future<void> init() async {
    try {
      await _loadProventos();
      if (proventos.isEmpty) Modular.to.pushReplacementNamed("/carteira/provento/crud");
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  _loadProventos() async {
    proventos = await AppCore.getProventosNaoLancadosByCarteira(_carteiraController.carteira.id);
  }

  @action
  Future<String> recebi(ProventoDTO provento) async {
    try {
      EventoProvento event = new EventoProvento(
          null,
          provento.data.millisecondsSinceEpoch,
          _carteiraController.carteira.id,
          AppCore.usuario.id,
          provento.valorTotal,
          provento.qtd.toDouble(),
          provento.papel,
          provento.id);

      await _eventService.save(event);
      await AppCore.notifyAddDelProvento();
      await _loadProventos();
      if (proventos.isEmpty) Modular.to.pop();
      return null;
    } on ApplicationException catch (e) {
      return e.toString();
    } catch (e) {
      LoggerUtil.error(e);
      return "Falha ao confirmar recebimento!";
    }
  }

  void recebiDiferente(ProventoDTO provento) {
    Modular.to.pushReplacementNamed("/carteira/provento/crud/${provento.id}");
  }
}
