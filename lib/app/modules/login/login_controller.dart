import 'dart:math';

import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/services/email_service.dart';
import 'package:alloc/app/shared/services/preference_service.dart';
import 'package:alloc/app/shared/services/usuario_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  IUsuarioService _usuarioService = Modular.get<UsuarioService>();
  IEmailService _emailService = Modular.get<EmailService>();
  IPreferenceService _preferenceService = Modular.get<PreferenceService>();
  IAlocacaoService _alocacaoService = Modular.get<AlocacaoService>();
  IAtivoService _ativoService = Modular.get<AtivoService>();
  ICarteiraService _carteiraService = Modular.get<CarteiraService>();
  String _codigoGerado;
  UsuarioModel _usuario;
  String codigo;
  @observable
  String email;

  @observable
  String error = "";

  @observable
  bool aguardaCodigo = false;

  @action
  Future<bool> entrar() async {
    try {
      error = "";
      if (aguardaCodigo) {
        return await _concluirLogin();
      } else {
        return await _iniciarLogin();
      }
    } catch (e) {
      LoggerUtil.error(e);
      error = "Falha ao realizar o login, tente novamente mais tarde.";
      return false;
    }
  }

  Future<bool> _iniciarLogin() async {
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
    return false;
  }

  Future<bool> _concluirLogin() async {
    if (codigo == _codigoGerado) {
      await baixarInformacoes();
      await _preferenceService.saveUsuario(_usuario);
      return true;
    } else {
      error = 'Código inválido!';
    }
    return false;
  }

  Future<void> baixarInformacoes() async {
    await _alocacaoService.getAllAlocacoes(_usuario.id, onlyCache: false);
    await _ativoService.getAtivos(_usuario.id, onlyCache: false);
    await _carteiraService.getCarteiras(_usuario.id, onlyCache: false);
  }

  @action
  changeEmail(text) {
    email = text;
    error = '';
    aguardaCodigo = false;
  }

  @action
  cancelar() {
    error = '';
    aguardaCodigo = false;
  }

  _enviarCodigo() async {
    var rng = new Random();
    String cod = rng.nextInt(100000).toString();
    bool result = await _emailService.sendMessage(
        'Seu código é: $cod', email, 'Código de Verificação');
    if (result) {
      _codigoGerado = cod;
    }
    return result;
  }
}
