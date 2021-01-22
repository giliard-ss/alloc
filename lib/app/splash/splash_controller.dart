import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/impl/preference_service.dart';
import 'package:alloc/app/shared/services/ipreference_service.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'splash_controller.g.dart';

@Injectable()
class SplashController = _SplashControllerBase with _$SplashController;

abstract class _SplashControllerBase with Store {
  IPreferenceService _preferenceService = Modular.get<PreferenceService>();

  Future<bool> verificaExisteLogin() async {
    UsuarioModel usuario = await _preferenceService.getUsuario();
    if (usuario == null) {
      return false;
    } else {
      await SharedMain.init(usuario);
      return true;
    }
  }
}
