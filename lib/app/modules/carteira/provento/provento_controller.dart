import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'provento_controller.g.dart';

@Injectable()
class ProventoController = _ProventoControllerBase with _$ProventoController;

abstract class _ProventoControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
