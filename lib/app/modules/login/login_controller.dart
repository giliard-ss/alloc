import 'dart:math';

import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/repositories/auth_repository.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/services/email_service.dart';
import 'package:alloc/app/shared/services/preference_service.dart';
import 'package:alloc/app/shared/services/usuario_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  IAuthRepository _authRepository = Modular.get<AuthRepository>();

  String _codigoGerado;
  User _usuario;
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
      _usuario = await _authRepository.getGoogleLogin();
      await baixarInformacoes();
      return true;
    } catch (e) {
      error = "Falha ao realizar login, tente novamente.";
      return false;
    }
  }

  Future<void> baixarInformacoes() async {
    await _alocacaoService.getAllAlocacoes(_usuario.uid, onlyCache: false);
    await _ativoService.getAtivos(_usuario.uid, onlyCache: false);
    await _carteiraService.getCarteiras(_usuario.uid, onlyCache: false);
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
}
