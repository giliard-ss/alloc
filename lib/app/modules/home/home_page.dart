import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/listener_firestore.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
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
      appBar: AppBar(
        title: Text("Alloc"),
      ),
      body: RefreshIndicator(
          onRefresh: controller.refresh,
          child: Container(
              padding: EdgeInsets.all(10),
              child: WidgetUtil.futureBuild(controller.init, _body))),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(children: [
        getCarteiras(),
      ]),
    );
  }

  _showNovaCarteiraDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nova Carteira'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Observer(
                  builder: (_) {
                    return TextField(
                      onChanged: (text) => controller.descricao = text,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText: controller.error,
                          labelText: "Título",
                          border: const OutlineInputBorder()),
                    );
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text("Concluir"),
              onPressed: () async {
                bool ok = await LoadingUtil.onLoading(
                    context, controller.salvarNovaCarteira);
                if (ok) Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget getCarteiras() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.wallet_giftcard,
              color: Color(0XFF01579B),
            ),
            title: Text(
              "Carteiras",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF01579B)),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                _showNovaCarteiraDialog();
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Observer(builder: (_) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.carteiras.length,
                itemBuilder: (context, index) {
                  CarteiraDTO carteira = controller.carteiras[index];

                  return ListTile(
                    onTap: () {
                      Modular.to.pushNamed("/carteira/${carteira.id}");
                    },
                    subtitle: Text(
                        "Aportado: ${carteira.totalAportado.toString()}     Aportar: ${carteira.getSaldo().toString()}  Dep: ${carteira.totalDeposito.toString()}"),
                    title: Text(carteira.descricao),
                    trailing:
                        Text(" ${carteira.totalAportadoAtual.toString()}"),
                  );
                });
          })
        ],
      ),
    );
  }
}
