import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/snackbar_util.dart';
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
            height: 150,
            color: Theme.of(context).primaryColor,
            child: _header(),
          ),
          Container(
            //plano de fundo
            decoration: BoxDecoration(
                color: Color(0xfff4f6f9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: _content(),
          ),
        ],
      ),
    );
  }

  _header() {
    return Observer(
      builder: (_) {
        return ListTile(
          title: Text(
            "R\$ " + controller.carteira.totalAportadoAtualString,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Total Atualizado",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              )),
        );
      },
    );
  }

  _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: controller.ativos.isNotEmpty,
          child: Flexible(
            child: _createButton(
                Icons.add_box_rounded, "Ativo", Colors.lightGreen, () {
              Modular.to.pushNamed("/carteira/ativo");
            }),
          ),
        ),
        Visibility(
          visible: controller.ativos.isNotEmpty,
          child: SizedBox(
            width: 15,
          ),
        ),
        Visibility(
          visible: controller.alocacoes.isNotEmpty,
          child: Flexible(
            child: _createButton(
                Icons.add_box_rounded, "Alocação", Colors.lightGreen, () {
              _showNovaAlocacaoDialog();
            }),
          ),
        ),
        Visibility(
          visible: controller.alocacoes.isNotEmpty,
          child: SizedBox(
            width: 15,
          ),
        ),
        Flexible(
          child: _createButton(Icons.upload_file, "Depósito", Colors.lightGreen,
              () {
            _showDepositoDialog();
          }),
        ),
        SizedBox(
          width: 15,
        ),
        Flexible(
          child: _createButton(
              Icons.download_done_outlined, "Saque", Colors.lightGreen, () {
            _showRetiradaDialog();
          }),
        ),
      ],
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
              child: _createButton(
                  Icons.add_box_rounded, "Ativo", Colors.lightGreen, () {
                Modular.to.pushNamed("/carteira/ativo");
              }),
            ),
            Flexible(
              child: _createButton(
                  Icons.add_box_rounded, "Alocação", Colors.lightGreen, () {
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
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    "RESUMO",
                    style: TextStyle(
                        color: Color(0xff103d6b),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                getResumoCarteira(),
                _buttons(),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
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

  Widget getResumoCarteira() {
    return Observer(
      builder: (_) {
        return Container(
          child: Column(
            children: [
              ListTile(
                title: Text("Aportado"),
                trailing: Text(controller.carteira.totalAportadoString),
              ),
              ListTile(
                title: Text("Saldo"),
                trailing: Text(controller.carteira.saldoString),
              ),
              ListTile(
                title: Text("Rendimento"),
                trailing: Text(controller.carteira.rendimentoTotalString),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _createButton(
      IconData icon, String text, Color color, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: 120,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
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
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              color: Color(0xffe9edf4),
                              child: ListTile(
                                onTap: () {
                                  Modular.to.pushNamed(
                                      "/carteira/sub-alocacao/${alocacao.id}");
                                },
                                leading: Icon(Icons.donut_small_rounded),
                                title: Text(
                                  alocacao.descricao,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                    " ${alocacao.totalAportadoAtualString}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                alocacao.totalInvestir < 0
                                    ? Icons.remove_circle
                                    : Icons.add_circle,
                                color: alocacao.totalInvestir < 0
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              title: Text(
                                "${alocacao.totalInvestir < 0 ? 'Vender' : 'Investir'}",
                              ),
                              trailing: Text(
                                alocacao.totalInvestirString,
                                style: TextStyle(
                                    color: alocacao.totalInvestir < 0
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
                                  trailing: Text(alocacao.totalAportadoString),
                                ),
                                ListTile(
                                  dense: true,
                                  title: Text("Alocação "),
                                  trailing: Text(
                                      alocacao.alocacaoPercent.toString() +
                                          "%"),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      },
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700]),
                          ),
                          leading: Icon(
                            Icons.assessment_outlined,
                            color: Colors.orange[700],
                          ),
                          trailing: Text(ativo.totalAportadoString,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700])),
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
    DialogUtil.showAlertDialog(context, title: "Alocação", content: Observer(
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
