import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/listener_firestore.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: controller.refresh,
          child: WidgetUtil.futureBuild(controller.init, _body)),
    );
  }

  _body() {
    return Column(children: [
      getCarteiras(),
      RaisedButton(
        onPressed: () {
          controller.refresh();
        },
      ),
    ]);
  }

  Widget getCarteiras() {
    return Observer(builder: (_) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: controller.carteiras.length,
          itemBuilder: (context, index) {
            CarteiraDTO carteira = controller.carteiras[index];

            return ListTile(
              subtitle: Text(
                  "Aportado: ${carteira.totalAportado.toString()}     Aportar: ${carteira.getSaldo().toString()}"),
              title: Text(carteira.descricao),
              trailing: Text(" ${carteira.totalAportadoAtual.toString()}"),
            );
          });
    });
  }
}
