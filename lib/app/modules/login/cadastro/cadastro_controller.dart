import 'dart:math';

import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/iemail_service.dart';
import 'package:alloc/app/shared/services/impl/email_service.dart';

import 'package:alloc/app/shared/services/impl/usuario_service.dart';

import 'package:alloc/app/shared/services/iusuario_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'cadastro_controller.g.dart';

@Injectable()
class CadastroController = _CadastroControllerBase with _$CadastroController;

abstract class _CadastroControllerBase with Store {
  IUsuarioService _usuarioService = Modular.get<UsuarioService>();

  IEmailService _emailService = Modular.get<EmailService>();

  String _codigoGerado;
  String email;
  String nome;
  String codigo;

  @observable
  String error = "";

  @observable
  bool aguardaCodigo = false;

  @action
  Future<bool> continuar() async {
    try {
      if (aguardaCodigo) {
        return await _concluirCadastro();
      } else {
        await _cadastrar();
        return false;
      }
    } on Exception catch (e) {
      error = "Falha ao cadastrar. Tente novamente mais tarde!";
      LoggerUtil.error(e);
      return false;
    }
  }

  Future<void> _cadastrar() async {
    var usuario = await _usuarioService.getUsuario(email);
    if (usuario != null) {
      error = 'Email já existe! Faça o login.';
      return;
    }
    bool enviou = await _enviarCodigo();

    if (enviou)
      aguardaCodigo = true;
    else
      error = 'Falha ao enviar código. Tente novamente mais tarde';
  }

  Future<bool> _concluirCadastro() async {
    if (codigo == _codigoGerado) {
      await _usuarioService.cadastrar(nome, email);
      return true;
    } else {
      error = "Código inválido!";
    }
    return false;
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
