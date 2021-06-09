import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/pages/provento/provento_controller.dart';
import 'package:alloc/app/shared/dtos/provento_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/evento_provento.dart';

import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'provento_crud_controller.g.dart';

@Injectable()
class ProventoCrudController = _ProventoCrudControllerBase with _$ProventoCrudController;

abstract class _ProventoCrudControllerBase with Store {
  CarteiraController _carteiraController = Modular.get();
  ProventoController _proventoController = Modular.get();

  IEventService _eventService = Modular.get<EventService>();
  String _idEvent;
  String _idProvento;

  @observable
  String error = "";

  DateTime data = DateTime.now();
  @observable
  String papel;
  double qtd;
  double valorTotal = 0;

  Future<void> init() async {
    try {
      if (!StringUtil.isEmpty(_idEvent)) {
        _loadAtributosByEventId(_idEvent);
      } else if (!StringUtil.isEmpty(_idProvento)) {
        _loadAtributosByProventoId(_idProvento);
      }
    } catch (e) {
      LoggerUtil.error(e);
      error = e.toString();
    }
  }

  Future<void> _loadAtributosByEventId(String idEvent) async {
    EventoProvento provento = await _eventService.getEventById(idEvent);
    data = provento.getData();
    papel = provento.papel;
    qtd = provento.qtd;
    valorTotal = provento.valor;
  }

  Future<void> _loadAtributosByProventoId(String idProvento) async {
    ProventoDTO provento = _proventoController.proventos.firstWhere((e) => e.id == idProvento);
    data = provento.data;
    papel = provento.papel;
    qtd = provento.qtd.toDouble();
    valorTotal = provento.valorTotal;
  }

  @action
  Future<bool> salvar() async {
    try {
      if (!papelValido) {
        error = "Papel não encontrado.";
        return false;
      }

      if (valorTotal == 0 || valorTotal == null) {
        error = "Informe o valor total!";
        return false;
      }

      EventoProvento provento = new EventoProvento(_idEvent, data.millisecondsSinceEpoch,
          _carteiraController.carteira.id, AppCore.usuario.id, valorTotal, qtd, papel, _idProvento);

      await _eventService.save(provento);
      await AppCore.notifyAddDelEvent();
      return true;
    } on ApplicationException catch (e) {
      error = e.toString();
    } catch (e) {
      error = "Falha ao finalizar compra!";
      LoggerUtil.error(e);
    }
    return false;
  }

  @computed
  bool get papelValido {
    return AppCore.allPapeis.where((e) => e == papel).isNotEmpty;
  }

  @action
  void setPapel(String papel) {
    this.papel = papel;
  }

  List<String> getSugestoes(String text) {
    if (text.trim().isEmpty || text.trim().length < 2) return null;
    return AppCore.allPapeis
        .where((e) => e.toUpperCase().indexOf(text.trim().toUpperCase()) >= 0)
        .toList();
  }

  set idEvent(value) => _idEvent = value;

  set idProvento(String value) => this._idProvento = value;
}
