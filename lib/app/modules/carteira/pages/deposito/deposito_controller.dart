import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'deposito_controller.g.dart';

@Injectable()
class DepositoController = _DepositoControllerBase with _$DepositoController;

abstract class _DepositoControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
