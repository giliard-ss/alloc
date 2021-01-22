import 'package:flutter/material.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _nomeTextField(),
            SizedBox(
              height: 10,
            ),
            _emailTextField(),
            SizedBox(
              height: 10,
            ),
            _continueButton(),
          ],
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
      onPressed: () {},
    );
  }
}
