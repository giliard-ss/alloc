import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'splash_controller.g.dart';

@Injectable()
class SplashController = _SplashControllerBase with _$SplashController;

abstract class _SplashControllerBase with Store {
  IAuthRepository _authRepository = Modular.get<AuthRepository>();

  Future<bool> verificaExisteLogin() async {
    //await _authRepository.googleLogout();
    User user = _authRepository.getUser();

    if (user != null) {
      await AppCore.init(UsuarioModel(user.uid, user.displayName, user.email));
    }
    return user != null;
  }
}
