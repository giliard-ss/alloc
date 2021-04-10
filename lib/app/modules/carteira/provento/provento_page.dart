import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'provento_controller.dart';

class ProventoPage extends StatefulWidget {
  final String title;
  const ProventoPage({Key key, this.title = "Provento"}) : super(key: key);

  @override
  _ProventoPageState createState() => _ProventoPageState();
}

class _ProventoPageState
    extends ModularState<ProventoPage, ProventoController> {
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
