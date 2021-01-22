import 'dart:math';

import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/iemail_service.dart';
import 'package:alloc/app/shared/services/impl/email_service.dart';
import 'package:alloc/app/shared/services/impl/preference_service.dart';
import 'package:alloc/app/shared/services/impl/usuario_service.dart';
import 'package:alloc/app/shared/services/ipreference_service.dart';
import 'package:alloc/app/shared/services/iusuario_service.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  IUsuarioService _usuarioService = Modular.get<UsuarioService>();
  IEmailService _emailService = Modular.get<EmailService>();
  IPreferenceService _preferenceService = Modular.get<PreferenceService>();
  String _codigo;
  UsuarioModel _usuario;

  @observable
  String email;

  @observable
  String error;

  @observable
  bool aguardaCodigo = false;

  @action
  entrar() async {
    _usuario = await _usuarioService.getUsuario(email);

    if (_usuario == null) {
      error = "Usuário não identificado.";
    } else {
      bool enviou = await _enviarCodigo();

      if (enviou) {
        aguardaCodigo = true;
      } else {
        error = 'Falha ao enviar código. Tente novamente mais tarde';
      }
    }
  }

  @action
  changeEmail(text) {
    email = text;
    error = null;
    aguardaCodigo = false;
  }

  @action
  changeCodigo(text) async {
    if (_codigo != null && _codigo.trim() != '' && text == _codigo) {
      _preferenceService.saveUsuario(_usuario);
      Modular.to.pushReplacementNamed("/home");
    }
  }

  _enviarCodigo() async {
    var rng = new Random();
    String cod = rng.nextInt(100000).toString();
    bool result = await _emailService.sendMessage(
        'Seu código é: $cod', email, 'Código de Verificação');
    if (result) {
      _codigo = cod;
    }
    return result;
  }
}
