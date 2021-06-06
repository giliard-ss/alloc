import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/evento_provento.dart';

import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'provento_controller.g.dart';

@Injectable()
class ProventoController = _ProventoControllerBase with _$ProventoController;

abstract class _ProventoControllerBase with Store {
  CarteiraController _carteiraController = Modular.get();
  IEventService _eventService = Modular.get<EventService>();
  String _id;
  @observable
  String error = "";

  DateTime data = DateTime.now();
  @observable
  String papel;
  double qtd;
  double valorTotal;

  Future<void> init() async {
    try {
      if (!StringUtil.isEmpty(_id)) {
        EventoProvento provento = await _eventService.getEventById(_id);
        data = provento.getData();
        papel = provento.papel;
        qtd = provento.qtd;
        valorTotal = provento.valor;
      }
    } catch (e) {
      LoggerUtil.error(e);
      error = e.toString();
    }
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

      EventoProvento provento = new EventoProvento(_id, data.millisecondsSinceEpoch,
          _carteiraController.carteira.id, AppCore.usuario.id, valorTotal, qtd, papel);

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

  set id(value) => _id = value;
}
