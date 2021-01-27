import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'carteira_controller.dart';

class CarteiraPage extends StatefulWidget {
  final String title;
  final String carteiraId;
  const CarteiraPage(this.carteiraId, {Key key, this.title = "Carteira"})
      : super(key: key);

  @override
  _CarteiraPageState createState() => _CarteiraPageState();
}

class _CarteiraPageState
    extends ModularState<CarteiraPage, CarteiraController> {
  //use 'controller' variable to access controller

  @override
  void initState() {
    controller.setCarteira(widget.carteiraId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(child: Text("Depositar"), value: "depositar"),
                PopupMenuItem(child: Text("Retirar"), value: "depositar"),
                PopupMenuItem(
                    child: Text("Excluir Carteira"), value: "depositar"),
              ],
              onSelected: (e) {},
            )
          ],
        ),
        body: WidgetUtil.futureBuild(controller.init, _body));
  }

  _body() {
    return Column(children: [
      getResumoCarteira(),
      SizedBox(
        height: 10,
      ),
      getAlocacoes(),
    ]);
  }

  Widget getResumoCarteira() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("Aportado"),
            trailing: Text(controller.carteira.totalAportado.toString()),
          ),
          ListTile(
            title: Text("Saldo"),
            trailing: Text(controller.carteira.getSaldo().toString()),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Flexible(
                  child: RaisedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: Text("Ativo"),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RaisedButton.icon(
                    onPressed: () {
                      _showNovaCarteiraDialog();
                    },
                    icon: Icon(Icons.add),
                    label: Text("Alocação"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getAlocacoes() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("Alocações",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF01579B))),
          ),
          Observer(builder: (_) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.alocacoes.length,
                itemBuilder: (context, index) {
                  AlocacaoDTO alocacao = controller.alocacoes[index];

                  return ListTile(
                    onTap: () {
                      Modular.to
                          .pushNamed("/carteira/sub-alocacao/${alocacao.id}");
                    },
                    subtitle: Text(
                        "Aportado: ${alocacao.totalAportado.toString()}     ${alocacao.totalInvestir < 0 ? 'Vender' : 'Investir'}: ${alocacao.totalInvestir.toString()}  "),
                    title: Text(alocacao.descricao),
                    trailing:
                        Text(" ${alocacao.totalAportadoAtual.toString()}"),
                  );
                });
          }),
        ],
      ),
    );
  }

  _showNovaCarteiraDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nova Alocação'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Observer(
                  builder: (_) {
                    return TextField(
                      onChanged: (text) => controller.novaAlocacaoDesc = text,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText: controller.novaAlocacaoError,
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
                    context, controller.salvarNovaAlocacao);
                if (ok) Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
