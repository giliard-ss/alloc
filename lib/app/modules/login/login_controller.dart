import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/impl/usuario_service.dart';
import 'package:alloc/app/shared/services/iusuario_service.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  IUsuarioService _usuarioService = Modular.get<UsuarioService>();
  String _codigoEnviado = "abc";
  @observable
  String email;

  @observable
  String error;

  @observable
  bool aguardaCodigo = false;

  @action
  entrar() async {
    UsuarioModel usuario = await _usuarioService.getUsuario(email);

    if (usuario == null) {
      error = "Usuário não identificado.";
    } else {
      aguardaCodigo = true;
    }
  }

  @action
  changeEmail(text) {
    email = text;
    error = null;
    aguardaCodigo = false;
  }

  @action
  changeCodigo(text) {
    if (text == _codigoEnviado) {
      Modular.to.pushReplacementNamed("/home");
    }
  }
}
