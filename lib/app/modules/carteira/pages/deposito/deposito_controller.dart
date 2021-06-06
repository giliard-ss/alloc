import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/evento_deposito.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'deposito_controller.g.dart';

@Injectable()
class DepositoController = _DepositoControllerBase with _$DepositoController;

abstract class _DepositoControllerBase with Store {
  CarteiraController _carteiraController = Modular.get();
  IEventService _eventService = Modular.get<EventService>();

  @observable
  String error;

  String _id;
  DateTime data;
  double valorDeposito;

  Future<void> init() async {
    try {
      data = DateTime.now();
      if (!StringUtil.isEmpty(_id)) {
        EventoDeposito deposito = await _eventService.getEventById(_id);
        valorDeposito = deposito.valor;
        data = deposito.getData();
      }
    } catch (e) {
      LoggerUtil.error(e);
      error = e.toString();
    }
  }

  bool isEdicao() {
    return _id != null;
  }

  Future<bool> salvarDeposito() async {
    try {
      if (valorDeposito == null || valorDeposito <= 0)
        throw new ApplicationException("Valor de depósito inválido!");

      EventoDeposito deposito;

      if (isEdicao()) {
        deposito = await _eventService.getEventById(_id);
        deposito.valor = valorDeposito;
        deposito.data = data.millisecondsSinceEpoch;
      } else {
        deposito = new EventoDeposito(null, data.millisecondsSinceEpoch,
            _carteiraController.carteira.id, AppCore.usuario.id, valorDeposito);
      }

      _eventService.save(deposito);

      await AppCore.notifyUpdateCarteira();
      return true;
    } on ApplicationException catch (e) {
      error = e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      error = "Falha ao salvar nova alocação.";
    }
    return false;
  }

  String get id => this._id;

  set id(String value) => this._id = value;
}
