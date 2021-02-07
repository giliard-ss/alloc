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
    return Column(
      children: [
        Observer(builder: (_) {
          return Column(
            children: [
              ListTile(
                  title: Text(
                    "CARTEIRAS",
                    style: TextStyle(
                        color: Color(0xff103d6b),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.add_box,
                      color: Color(0xff103d6b),
                    ),
                    onPressed: () {
                      _showNovaCarteiraDialog();
                    },
                  )),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.carteiras.length,
                  itemBuilder: (context, index) {
                    CarteiraDTO carteira = controller.carteiras[index];

                    ListTile(
                      onTap: () {
                        Modular.to.pushNamed("/carteira/${carteira.id}");
                      },
                      subtitle: Text(
                          "Aportado: ${carteira.totalAportado.toString()}     Aportar: ${carteira.getSaldo().toString()}  Dep: ${carteira.totalDeposito.toString()}"),
                      title: Text(carteira.descricao),
                      trailing: Text(" ${carteira.totalAportadoAtualString}"),
                    );

                    return Card(
                      child: Column(
                        children: [
                          Container(
                            //  color: Color(0xffe9edf4),
                            child: ListTile(
                              onTap: () {
                                Modular.to
                                    .pushNamed("/carteira/${carteira.id}");
                              },
                              leading: Icon(Icons.account_balance_wallet),
                              title: Text(
                                carteira.descricao,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                  " ${carteira.totalAtualizadoString}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              carteira.getSaldo() < 0
                                  ? Icons.remove_circle
                                  : Icons.add_circle,
                              color: carteira.getSaldo() < 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            title: Text(
                              "${carteira.getSaldo() < 0 ? 'Vender' : 'Investir'}",
                            ),
                            trailing: Text(
                              carteira.saldoString,
                              style: TextStyle(
                                  color: carteira.getSaldo() < 0
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ExpansionTile(
                            title: Text(
                              "Mais",
                              style: TextStyle(fontSize: 14),
                            ),
                            children: [
                              ListTile(
                                dense: true,
                                title: Text("Total Aportado"),
                                trailing: Text(carteira.totalAportadoString),
                              ),
                              ListTile(
                                dense: true,
                                title: Text("Rendimento "),
                                trailing: Text(carteira.rendimentoTotalString),
                              ),
                              ListTile(
                                dense: true,
                                title: Text("Depositado "),
                                trailing: Text(carteira.totalDepositoString),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ],
          );
        })
      ],
    );
  }
}
