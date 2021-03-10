import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/widgets/carteira_icon.dart';
import 'package:alloc/app/modules/home/widgets/cotacao_card.dart';
import 'package:alloc/app/modules/home/widgets/title_widget.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:alloc/app/shared/widgets/image_base64_widget.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';

import 'widgets/carousel_with_indicator.dart';

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
          elevation: 1,
          title: Text("Alloc"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: drawerHeader(),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ],
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: WidgetUtil.futureBuild(controller.init, _body)));
  }

  Widget getImage() {
    return ImageBase64Widget(
      base64Image: AppCore.usuario.photoBase64,
      widgetError: Icon(
        Icons.person,
        size: 50,
      ),
    );
  }

  Widget drawerHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getImage(),
        // Icon(
        //   Icons.person,
        //   size: 70,
        // ),
        Text(AppCore.usuario.nome),
        Text(AppCore.usuario.email)
      ],
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // menu(),
        resumo(),
        getCarteiras(),
        SizedBox(
          height: 15,
        ),
        carousel()
      ]),
    );
  }

  Widget menu() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Olá, " + AppCore.usuario.nome.split(" ")[0],
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ],
    );
  }

  Widget resumo() {
    return Observer(
      builder: (_) {
        List variacao = controller.getVariacaoPatrimonio();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Text("PATRIMÔNIO"),
            Text(
              GeralUtil.doubleToMoney(controller.patrimonio),
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Observer(
              builder: (_) {
                return Text("Variação " + controller.lastUpdate);
              },
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  width: 180,
                  child: Text(
                    GeralUtil.doubleToMoney(variacao[0]),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                VariacaoPercentualWidget(
                  withIcon: true,
                  withSinal: false,
                  value: variacao[1],
                  fontSize: 16,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        );
      },
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

  Widget carousel() {
    return Observer(
      builder: (_) {
        return Visibility(
          visible: controller.acoes.isNotEmpty || controller.fiis.isNotEmpty,
          child: CarouselWithIndicator(
            height:
                ((controller.maiorQuantItemsExistenteListas.toDouble()) * 50) +
                    110,
            items: cotacaoAtivosCard(),
          ),
        );
      },
    );
  }

  List<Widget> cotacaoAtivosCard() {
    List<Widget> list = [];
    if (controller.acoes.isNotEmpty) {
      list.add(Observer(
        builder: (_) {
          return CotacaoCard(
            cotacaoIndice: controller.getCotacaoIndiceByTipo(TipoAtivo.ACAO),
            variacaoTotal: controller.getVariacaoTotalAcoes(),
            ativos: controller.acoes,
            onTap: () {
              Modular.to.pushNamed("/home/cotacao/${TipoAtivo.ACAO.code}");
            },
            title: "Ações e ETFs",
          );
        },
      ));
    }
    if (controller.fiis.isNotEmpty) {
      list.add(Observer(
        builder: (_) {
          return CotacaoCard(
            cotacaoIndice: controller.getCotacaoIndiceByTipo(TipoAtivo.FII),
            variacaoTotal: controller.getVariacaoTotalFiis(),
            ativos: controller.fiis,
            onTap: () {
              Modular.to.pushNamed("/home/cotacao/${TipoAtivo.FII.code}");
            },
            title: "Fundos Imobiliários",
          );
        },
      ));
    }
    return list;
  }

  Widget subtitleCarteira(CarteiraDTO carteira) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                GeralUtil.doubleToMoney(
                  carteira.totalAtualizado,
                ),
                style: TextStyle(fontSize: 15, color: Colors.black)),
            VariacaoPercentualWidget(
              withSinal: false,
              withIcon: true,
              value: controller.getVariacaoCarteira(carteira.id),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
            (carteira.saldo < 0
                ? ('Vender ' +
                    (GeralUtil.doubleToMoney(carteira.saldo * -1)).toString())
                : 'Aplicar ' + GeralUtil.doubleToMoney(carteira.saldo)),
            style: TextStyle(color: Colors.grey)),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Widget getCarteiras() {
    return Column(
      children: [
        Observer(builder: (_) {
          return Column(
            children: [
              TitleWidget(
                title: "Carteiras",
                rightItems: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                    ),
                    onPressed: _showNovaCarteiraDialog,
                  )
                ],
                withDivider: true,
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.carteiras.length,
                  itemBuilder: (context, index) {
                    CarteiraDTO carteira = controller.carteiras[index];

                    return Container(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Modular.to.pushNamed("/carteira/${carteira.id}");
                            },
                            leading: CarteiraIcon(carteira.descricao),
                            title: Text(
                              carteira.descricao,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: subtitleCarteira(carteira),
                          ),
                          Visibility(
                              visible: controller.carteiras.length > 1 &&
                                  (controller.carteiras.length - 1) != index,
                              child: Divider(
                                height: 10,
                                color: Colors.grey,
                              ))
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
