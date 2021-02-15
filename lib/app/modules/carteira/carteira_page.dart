import 'package:alloc/app/modules/carteira/widgets/alocacoes_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/ativos_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/custom_button_widget.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(controller.title),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(child: Text("Configuração"), value: "config"),
                PopupMenuItem(
                    child: Text("Excluir Carteira"), value: "excluirCarteira"),
              ],
              onSelected: (e) {
                if (e == 'excluirCarteira') {
                  _showExcluirCarteiraDialog();
                }
                if (e == 'config') {
                  Modular.to.pushNamed("/carteira/config");
                }
              },
            )
          ],
        ),
        body: WidgetUtil.futureBuild(controller.init, _body));
  }

  _body() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            //header
            padding: EdgeInsets.only(top: 20),
            height: 200,

            child: _header(),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).primaryColor,
                  Color(0xff132a53)
                ])),
          ),
          Container(
            //plano de fundo
            decoration: BoxDecoration(
                //color: Color(0xfff4f6f9),
                ),
            margin: EdgeInsets.only(top: 175),
            padding: EdgeInsets.only(top: 70),
            child: _content(),
          ),
          Container(
            //resumo carteira
            margin: EdgeInsets.fromLTRB(10, 140, 10, 0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  _totalInvestir(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _header() {
    return Observer(
      builder: (_) {
        return Column(
          children: [
            ListTile(
              title: Text(
                GeralUtil.doubleToMoney(controller.carteira.totalAportadoAtual),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Total Atualizado",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Container(
                    width: 150,
                    height: 45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            GeralUtil.doubleToMoney(
                                controller.carteira.totalAportado,
                                leftSymbol: ""),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(
                          "Aplicado",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Container(
                    width: 80,
                    height: 45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (controller.carteira.rendimentoTotal > 0 ? '+' : '') +
                              controller.carteira.rendimentoTotalPercentString +
                              "%",
                          style: TextStyle(
                              color: controller.carteira.rendimentoTotal < 0
                                  ? Color(0xffff6666)
                                  : Colors.greenAccent[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Container(
                    width: 150,
                    height: 45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            (controller.carteira.rendimentoTotal > 0
                                    ? '+'
                                    : '') +
                                GeralUtil.doubleToMoney(
                                    controller.carteira.rendimentoTotal,
                                    leftSymbol: ""),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(
                          "Rendimento",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  _buttons() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible:
                controller.ativos.isNotEmpty && controller.alocacoes.isEmpty,
            child: Flexible(
              child: CustomButtonWidget(
                  icon: Icons.add_chart,
                  text: "Ativo",
                  onPressed: () {
                    Modular.to.pushNamed("/carteira/ativo");
                  }),
            ),
          ),
          Visibility(
            visible: controller.alocacoes.isNotEmpty,
            child: Flexible(
              child: CustomButtonWidget(
                  icon: Icons.my_library_add_outlined,
                  text: "Alocação",
                  onPressed: () {
                    _showNovaAlocacaoDialog();
                  }),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: CustomButtonWidget(
                icon: Icons.local_atm_sharp,
                text: "Depósito",
                onPressed: () {
                  _showDepositoDialog();
                }),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: CustomButtonWidget(
                icon: Icons.monetization_on_outlined,
                text: "Saque",
                onPressed: () {
                  _showRetiradaDialog();
                }),
          ),
        ],
      ),
    );
  }

  _contentCarteiraNova() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        Text(
          "Carteira Nova!",
          style: TextStyle(fontSize: 16),
        ),
        Text("Escolha abaixo se deseja incluir alocações ou ativos"),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: CustomButtonWidget(
                  icon: Icons.add_chart,
                  text: "Ativo",
                  onPressed: () {
                    Modular.to.pushNamed("/carteira/ativo");
                  }),
            ),
            Flexible(
              child: CustomButtonWidget(
                  icon: Icons.add_box_rounded,
                  text: "Alocação",
                  onPressed: () {
                    _showNovaAlocacaoDialog();
                  }),
            ),
          ],
        )
      ],
    );
  }

  _content() {
    return Column(
      children: [
        Observer(
          builder: (_) {
            return Visibility(
              visible:
                  controller.alocacoes.isEmpty && controller.ativos.isEmpty,
              child: _contentCarteiraNova(),
            );
          },
        ),
        Observer(
          builder: (_) {
            return Visibility(
              visible: controller.alocacoes.isNotEmpty ||
                  controller.ativos.isNotEmpty,
              child: Column(children: [
                _buttons(),
                SizedBox(
                  height: 20,
                ),
                _getAtivos(),
                _getAlocacoes()
              ]),
            );
          },
        )
      ],
    );
  }

  Widget _totalInvestir() {
    return Observer(
      builder: (_) {
        return Container(
          height: 80,
          child: Center(
            child: ListTile(
              title: Text(
                "Saldo",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff132a53)),
              ),
              subtitle: Text(
                "Depositado " +
                    GeralUtil.doubleToMoney(controller.carteira.totalDeposito),
                style: TextStyle(fontSize: 12),
              ),
              trailing: Text(
                GeralUtil.doubleToMoney(controller.carteira.saldo),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff132a53)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getAlocacoes() {
    return Observer(
      builder: (_) {
        return Visibility(
            visible: controller.alocacoes.isNotEmpty,
            child: AlocacoesWidget(
              alocacoes: controller.alocacoes,
              fncExcluir: controller.excluirAlocacao,
            ));
      },
    );
  }

  Widget _getAtivos() {
    return Observer(builder: (_) {
      return Visibility(
        //mostrar ativos somente se nao houve subalocacoes , ou seja, se estiver no ultimo nivel
        visible: controller.ativos.isNotEmpty && controller.alocacoes.isEmpty,
        child: AtivosWidget(
          ativos: controller.ativos,
          fncExcluir: controller.excluir,
        ),
      );
    });
  }

  _showExcluirCarteiraDialog() {
    DialogUtil.showAlertDialog(context,
        title: "Excluir Carteira",
        content: Text("Tem certeza que deseja excluir esta carteira?"),
        onConcluir: () async {
      String msg =
          await LoadingUtil.onLoading(context, controller.excluirCarteira);
      if (msg != null) {
        Navigator.of(context).pop();
        DialogUtil.showMessageDialog(context, msg);
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    });
  }

  _showRetiradaDialog() {
    controller.limparErrorDialog();
    DialogUtil.showAlertDialog(context, title: "Saque", content: Observer(
      builder: (_) {
        return TextField(
          keyboardType: TextInputType.number,
          onChanged: (text) => controller.valorSaque = double.parse(text),
          decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              errorText: controller.errorDialog,
              labelText: "Valor",
              border: const OutlineInputBorder()),
        );
      },
    ), onConcluir: () async {
      bool ok = await LoadingUtil.onLoading(context, controller.salvarSaque);
      if (ok) {
        Navigator.of(context).pop();
      }
    });
  }

  _showDepositoDialog() {
    controller.limparErrorDialog();
    DialogUtil.showAlertDialog(context, title: "Depósito", content: Observer(
      builder: (_) {
        return TextField(
          keyboardType: TextInputType.number,
          onChanged: (text) => controller.valorDeposito = double.parse(text),
          decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              errorText: controller.errorDialog,
              labelText: "Valor",
              border: const OutlineInputBorder()),
        );
      },
    ), onConcluir: () async {
      bool ok = await LoadingUtil.onLoading(context, controller.salvarDeposito);
      if (ok) {
        Navigator.of(context).pop();
      }
    });
  }

  _showNovaAlocacaoDialog() {
    controller.limparErrorDialog();
    DialogUtil.showAlertDialog(context, title: "Nova Alocação",
        content: Observer(
      builder: (_) {
        return TextField(
          keyboardType: TextInputType.name,
          onChanged: (text) => controller.novaAlocacaoDesc = text,
          decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              errorText: controller.errorDialog,
              labelText: "Título",
              border: const OutlineInputBorder()),
        );
      },
    ), onConcluir: () async {
      bool ok =
          await LoadingUtil.onLoading(context, controller.salvarNovaAlocacao);
      if (ok) {
        Navigator.of(context).pop();
      }
    });
  }
}
