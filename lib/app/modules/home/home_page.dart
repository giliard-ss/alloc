import 'package:alloc/app/modules/carteira/widgets/carteira_icon.dart';
import 'package:alloc/app/modules/home/widgets/cotacao_card.dart';
import 'package:alloc/app/modules/home/widgets/title_widget.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';

import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        title: Text("Alloc"),
      ),
      body: RefreshIndicator(
          onRefresh: controller.refresh,
          child: Container(
              padding: EdgeInsets.all(15),
              child: WidgetUtil.futureBuild(controller.init, _body))),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(children: [
        getCarteiras(),
        SizedBox(
          height: 15,
        ),
        carousel()
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

  Widget carousel() {
    return Observer(
      builder: (_) {
        return Visibility(
          visible: controller.acoes.isNotEmpty || controller.fiis.isNotEmpty,
          child: CarouselWithIndicator(
            height:
                ((controller.maiorQuantItemsExistenteListas.toDouble()) * 50) +
                    105,
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
              value: carteira.rendimentoTotalPercent,
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
