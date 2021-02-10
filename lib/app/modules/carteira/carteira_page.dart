import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
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

  List colors = [0xff818099, 0xffa18799, 0xff7c8381, 0xffa9a3b2];
  List colorsBlack = [0xff504f63, 0xff725a6b, 0xff575c5a, 0xff71687d];

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

  _getColor(int index, List colors) {
    if (index < colors.length - 1) return colors[index];
    int value = index;
    while (true) {
      if (value > colors.length - 1)
        value = value - colors.length;
      else
        return colors[value];
    }
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
              color: Color(0xfff4f6f9),
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
                "R\$ " + controller.carteira.totalAportadoAtualString,
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
                        Text(controller.carteira.totalAportadoString,
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
                                controller.carteira.rendimentoTotalString,
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
              child: _createButton(Icons.add_chart, "Ativo", () {
                Modular.to.pushNamed("/carteira/ativo");
              }),
            ),
          ),
          Visibility(
            visible: controller.alocacoes.isNotEmpty,
            child: Flexible(
              child:
                  _createButton(Icons.my_library_add_outlined, "Alocação", () {
                _showNovaAlocacaoDialog();
              }),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: _createButton(Icons.local_atm_sharp, "Depósito", () {
              _showDepositoDialog();
            }),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: _createButton(Icons.monetization_on_outlined, "Saque", () {
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
              child: _createButton(Icons.add_chart, "Ativo", () {
                Modular.to.pushNamed("/carteira/ativo");
              }),
            ),
            Flexible(
              child: _createButton(Icons.add_box_rounded, "Alocação", () {
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
                "Investir",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff132a53)),
              ),
              subtitle: Text(
                "Depositado " + controller.carteira.totalDepositoString,
                style: TextStyle(fontSize: 12),
              ),
              trailing: Text(
                controller.carteira.saldoString,
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

  Widget _createButton(IconData icon, String text, Function onPressed,
      {color: Colors.orange}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // decoration: BoxDecoration(
        //   color: color,
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        // ),
        width: 120,
        height: 70,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: color,
                size: 30,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAlocacoes() {
    return Observer(
      builder: (_) {
        return Visibility(
          visible: controller.alocacoes.isNotEmpty,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "ALOCAÇÕES",
                  style: TextStyle(
                      color: Color(0xff103d6b),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Divider(
                color: Colors.grey[300],
                height: 5,
                indent: 15,
                endIndent: 15,
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.alocacoes.length,
                  itemBuilder: (context, index) {
                    AlocacaoDTO alocacao = controller.alocacoes[index];

                    return Dismissible(
                      key: Key(alocacao.id),
                      confirmDismiss: (e) async {
                        String msg =
                            await LoadingUtil.onLoading(context, () async {
                          return await controller.excluirAlocacao(alocacao);
                        });

                        if (msg == null) {
                          return true;
                        }
                        DialogUtil.showMessageDialog(context, msg);
                        return false;
                      },
                      background: Container(),
                      secondaryBackground: _slideRightBackground(),
                      direction: DismissDirection.endToStart,
                      child: ExpansionTile(
                        leading: _iconAlocacoes(alocacao,
                            color: Color(
                              _getColor(index, colors),
                            ),
                            colorDark: Color(
                              _getColor(index, colorsBlack),
                            )),
                        subtitle: Text(
                            (alocacao.totalInvestir < 0
                                ? ('Vender ' +
                                    (GeralUtil.limitaCasasDecimais(
                                            alocacao.totalInvestir * -1))
                                        .toString())
                                : 'Investir ' + alocacao.totalInvestirString),
                            style: TextStyle(
                                color: alocacao.totalInvestir < 0
                                    ? Colors.red
                                    : Colors.green)),
                        title: Text(
                          alocacao.descricao,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        children: [
                          ListTile(
                            dense: true,
                            title: Text("Rendimento"),
                            trailing: Text(
                              (alocacao.rendimento > 0 ? '+' : '') +
                                  alocacao.rendimentoString,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: alocacao.rendimento < 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            title: Text("Rendimento Percentual"),
                            trailing: Text(
                              (alocacao.rendimento > 0 ? '+' : '') +
                                  alocacao.rendimentoPercentString +
                                  "%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: alocacao.rendimento < 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            title: Text("Total Aportado"),
                            trailing: Text(alocacao.totalAportadoString),
                          ),
                          ListTile(
                            dense: true,
                            title: Text("Alocação "),
                            trailing:
                                Text(alocacao.alocacaoPercentString + "%"),
                          ),
                          Container(
                            color: Color(0xffe7ecf4),
                            child: ListTile(
                              dense: true,
                              onTap: () {
                                Modular.to.pushNamed(
                                    "/carteira/sub-alocacao/${alocacao.id}");
                              },
                              title: Text(
                                alocacao.totalInvestir < 0
                                    ? 'Vender'
                                    : 'Investir',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: alocacao.totalInvestir < 0
                                        ? Colors.red
                                        : Colors.green),
                              ),
                              trailing: Text(alocacao.totalInvestirString,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: (alocacao.totalInvestir < 0
                                          ? Colors.red
                                          : Colors.green))),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _iconAlocacoes(AlocacaoDTO aloc,
      {color: Colors.orange, colorDark: Colors.black}) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, colorDark])),
          ),
          Positioned(
            top: 5,
            left: 7,
            child: Container(
              width: 46,
              height: 46,
              child: Center(
                  child: Text(
                aloc.alocacaoPercentString + "%",
                style: TextStyle(fontWeight: FontWeight.bold, color: colorDark),
              )),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xfff4f6f9)),
            ),
          )
        ],
      ),
    );
  }

  Widget _getAtivos() {
    return Observer(builder: (_) {
      return Visibility(
        //mostrar ativos somente se nao houve subalocacoes , ou seja, se estiver no ultimo nivel
        visible: controller.ativos.isNotEmpty && controller.alocacoes.isEmpty,
        child: Column(
          children: [
            ListTile(
              title: Text(
                "ATIVOS",
                style: TextStyle(
                    color: Color(0xff103d6b),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.ativos.length,
                itemBuilder: (context, index) {
                  AtivoModel ativo = controller.ativos[index];
                  CotacaoModel cotacao = controller.getCotacao(ativo.papel);
                  String totalAportadoAtual = GeralUtil.limitaCasasDecimais(
                          ativo.qtd.toInt() * cotacao.ultimo.toDouble())
                      .toString();

                  return Dismissible(
                    key: Key(ativo.id),
                    confirmDismiss: (e) async {
                      String msg =
                          await LoadingUtil.onLoading(context, () async {
                        return await controller.excluir(ativo);
                      });

                      if (msg == null) {
                        return true;
                      }
                      DialogUtil.showMessageDialog(context, msg);
                      return false;
                    },
                    background: Container(),
                    secondaryBackground: _slideRightBackground(),
                    direction: DismissDirection.endToStart,
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            ativo.papel,
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                          subtitle: Text(
                              controller.getCotacao(ativo.papel).ultimoString),
                          trailing: Text(totalAportadoAtual,
                              style: TextStyle(color: Colors.grey[800])),
                          children: [
                            ListTile(
                              dense: true,
                              title: Text("Total Aportado"),
                              trailing: Text(ativo.totalAportadoString),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Alocação"),
                              trailing:
                                  Text(ativo.alocacaoPercent.toString() + " %"),
                            )
                          ],
                        ),
                        Divider(
                          height: 5,
                        )
                      ],
                    ),
                  );
                }),
          ],
        ),
      );
    });
  }

  Widget _slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
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
