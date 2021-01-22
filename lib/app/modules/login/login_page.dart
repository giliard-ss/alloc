import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _emailTextField(),
            _codigoTextField(),
            _entrarButton(),
            _cadastrarButton(),
            _cancelarButton()
          ],
        ),
      ),
    );
  }

  _cadastrarButton() {
    return Observer(
      builder: (_) {
        return Visibility(
          visible: controller.aguardaCodigo == false,
          child: RaisedButton(
            child: Text('Cadastrar'),
            onPressed: () => Modular.to.pushNamed("/cadastro"),
          ),
        );
      },
    );
  }

  _cancelarButton() {
    return Observer(
      builder: (_) {
        return Visibility(
          visible: controller.aguardaCodigo == true,
          child: RaisedButton(
              child: Text('Cancelar'),
              onPressed: () => controller.aguardaCodigo = false),
        );
      },
    );
  }

  _entrarButton() {
    return Observer(
      builder: (_) {
        return Visibility(
          visible: controller.aguardaCodigo == false,
          child: RaisedButton(
            child: Text('Entrar'),
            onPressed: controller.entrar,
          ),
        );
      },
    );
  }

  _emailTextField() {
    return Observer(builder: (_) {
      return TextField(
        onChanged: controller.changeEmail,
        decoration: InputDecoration(
            labelText: "E-mail",
            errorText: controller.error,
            errorStyle: TextStyle(color: Colors.red),
            suffixIcon: Icon(Icons.email),
            border: const OutlineInputBorder()),
      );
    });
  }

  _codigoTextField() {
    return Observer(
      builder: (_) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: controller.aguardaCodigo == true,
              child: TextField(
                autofocus: true,
                onChanged: controller.changeCodigo,
                decoration: InputDecoration(
                    labelText: "Código ",
                    helperText: "Código enviado para seu e-mail",
                    suffixIcon: Icon(Icons.security),
                    border: const OutlineInputBorder()),
              ),
            ),
          ],
        );
      },
    );
  }
}
