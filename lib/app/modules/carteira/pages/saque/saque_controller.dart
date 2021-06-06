import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/evento_saque.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'saque_controller.g.dart';

@Injectable()
class SaqueController = _SaqueControllerBase with _$SaqueController;

abstract class _SaqueControllerBase with Store {
  CarteiraController _carteiraController = Modular.get();
  IEventService _eventService = Modular.get<EventService>();

  @observable
  String error;

  String _id;
  DateTime data;
  double valorSaque;

  Future<void> init() async {
    try {
      data = DateTime.now();
      if (!StringUtil.isEmpty(_id)) {
        EventoSaque saque = await _eventService.getEventById(_id);
        valorSaque = saque.valor;
        data = saque.getData();
      }
    } catch (e) {
      LoggerUtil.error(e);
      error = e.toString();
    }
  }

  bool isEdicao() {
    return _id != null;
  }

  double getSaldoAtual() {
    return _carteiraController.carteira.saldo;
  }

  Future<bool> salvarSaque() async {
    try {
      if (valorSaque == null || valorSaque <= 0)
        throw new ApplicationException("Valor de saque inválido!");

      if (_carteiraController.carteira.saldo < valorSaque)
        throw new ApplicationException("Valor de saque acima do saldo!");
      EventoSaque saque;
      if (isEdicao()) {
        saque = await _eventService.getEventById(_id);
        saque.valor = valorSaque;
        saque.data = data.millisecondsSinceEpoch;
      } else {
        saque = new EventoSaque(null, data.millisecondsSinceEpoch, _carteiraController.carteira.id,
            AppCore.usuario.id, valorSaque);
      }

      _eventService.save(saque);
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

  @action
  void onChangedValorSaque(valor) {
    valorSaque = valor;
    error = null;
  }

  String get id => this._id;

  set id(String value) => this._id = value;
}
