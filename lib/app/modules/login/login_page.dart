import 'dart:io';

import 'package:alloc/app/shared/utils/loading_util.dart';
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _errorText(),
                SizedBox(
                  height: 10,
                ),
                _emailTextField(),
                _codigoTextField(),
                _entrarButton(),
                _cadastrarButton(),
                _cancelarButton()
              ],
            ),
          ),
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
            onPressed: () => Modular.to.pushNamed("/login/cadastro"),
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
              child: Text('Cancelar'), onPressed: controller.cancelar),
        );
      },
    );
  }

  _entrarButton() {
    return RaisedButton(
      child: Text('Entrar'),
      onPressed: () async {
        LoadingUtil.start(context);
        bool goHome = await controller.entrar();
        if (goHome) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        } else {
          LoadingUtil.end(context);
        }
      },
    );
  }

  _emailTextField() {
    return TextField(
      onChanged: controller.changeEmail,
      decoration: InputDecoration(
          labelText: "E-mail",
          suffixIcon: Icon(Icons.email),
          border: const OutlineInputBorder()),
    );
  }

  _errorText() {
    return Observer(
      builder: (_) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible:
                  (controller.error != null && controller.error.isNotEmpty),
              child: Text(
                controller.error,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
                onChanged: (text) => controller.codigo = text,
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
