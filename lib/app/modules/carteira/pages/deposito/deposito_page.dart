import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'deposito_controller.dart';

class DepositoPage extends StatefulWidget {
  final String title;
  const DepositoPage({Key key, this.title = "Deposito"}) : super(key: key);

  @override
  _DepositoPageState createState() => _DepositoPageState();
}

class _DepositoPageState
    extends ModularState<DepositoPage, DepositoController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
