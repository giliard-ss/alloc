import 'dart:ui';

import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'cadastro_controller.dart';

class CadastroPage extends StatefulWidget {
  final String title;
  const CadastroPage({Key key, this.title = "Cadastro"}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState
    extends ModularState<CadastroPage, CadastroController> {
  //use 'controller' variable to access controller

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
                _nomeTextField(),
                SizedBox(
                  height: 10,
                ),
                _emailTextField(),
                SizedBox(
                  height: 10,
                ),
                _codigoTextField(),
                SizedBox(
                  height: 10,
                ),
                _continueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _nomeTextField() {
    return TextField(
      onChanged: (value) => controller.nome = value,
      decoration: InputDecoration(
          labelText: "Nome",
          suffixIcon: Icon(Icons.person),
          border: const OutlineInputBorder()),
    );
  }

  _emailTextField() {
    return TextField(
      onChanged: (value) => controller.email = value,
      decoration: InputDecoration(
          labelText: "E-mail",
          suffixIcon: Icon(Icons.email),
          border: const OutlineInputBorder()),
    );
  }

  _continueButton() {
    return RaisedButton(
      child: Text('Continuar'),
      onPressed: () async {
        try {
          LoadingUtil.start(context);
          bool concluiu = await controller.continuar();
          if (concluiu) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          } else {
            LoadingUtil.end(context);
          }
        } on Exception catch (e) {
          LoadingUtil.end(context);
        }
      },
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
