import 'package:alloc/app/shared/listener_firestore.dart';
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
    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Observer(
          builder: (_) {
            // print(controller.cotacoes.value[0].ultimo);
            // return Text(controller.cotacoes.value[0].ultimo.toString());
            print(controller.cotacoes.value[0].ultimo);
            return Text("");
          },
        ),
        RaisedButton(
          onPressed: () {},
        ),
        RaisedButton(
          onPressed: () {
            ListenerFirestore.stop();
          },
        )
      ],
    );
    /* return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: controller.carteiras.length,
        itemBuilder: (context, index) {
          CarteiraModel carteira = controller.carteiras[index];
          return ListTile(
            subtitle: Text("Aportado: 752,20"),
            title: Text(carteira.descricao),
            trailing: Text("Saldo: 721,00"),
          );
        }); */
  }

  // test() async {
  //   await Firebase.initializeApp();
  //   FirebaseFirestore.instance
  //       .collection('cotacao')
  //       .where("id", whereIn: ["IRBR3"])
  //       .snapshots()
  //       .listen((result) {
  //         result.docs.forEach((d) {
  //           print(d.data());
  //         });
  //       });
  // }
}
