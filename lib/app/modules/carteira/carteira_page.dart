import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
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
    return SingleChildScrollView(
      child: Column(children: [
        getResumoCarteira(),
        SizedBox(
          height: 10,
        ),
        _getButtons(),
        SizedBox(
          height: 10,
        ),
        _getAtivos(),
        _getAlocacoes()
      ]),
    );
  }

  Widget getResumoCarteira() {
    return Observer(
      builder: (_) {
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
              ListTile(
                title: Text("Atual"),
                trailing:
                    Text(controller.carteira.totalAportadoAtual.toString()),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _getButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: _createButton(
                  Icons.add_box_rounded, "Ativo", Colors.lightBlue, () {
                Modular.to.pushNamed("/carteira/ativo");
              }),
            ),
            Flexible(
              child: _createButton(
                  Icons.add_box_rounded, "Alocação", Colors.lightGreen, () {
                _showNovaAlocacaoDialog();
              }),
            ),
            Flexible(
              child: _createButton(
                  Icons.settings, "Configurar", Colors.lightGreen, () {}),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: _createButton(
                  Icons.upload_file, "Depósito", Colors.lightGreen, () {
                _showDepositoDialog();
              }),
            ),
            Flexible(
              child: _createButton(
                  Icons.download_done_outlined, "Saque", Colors.lightGreen, () {
                _showRetiradaDialog();
              }),
            ),
            Flexible(
              child: _createButton(
                  Icons.delete, "Excluir Carteira", Colors.lightGreen, () {
                _showExcluirCarteiraDialog();
              }),
            )
          ],
        )
      ],
    );
  }

  Widget _createButton(
      IconData icon, String text, Color color, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: color,
        width: 120,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 20,
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
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text("Alocações",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF01579B))),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
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
                        child: ListTile(
                          onTap: () {
                            Modular.to.pushNamed(
                                "/carteira/sub-alocacao/${alocacao.id}");
                          },
                          subtitle: Text(
                              "Aportado: ${alocacao.totalAportado.toString()}     ${alocacao.totalInvestir < 0 ? 'Vender' : 'Investir'}: ${alocacao.totalInvestir.toString()}  "),
                          title: Text(alocacao.descricao),
                          trailing: Text(
                              " ${alocacao.totalAportadoAtual.toString()}"),
                        ),
                      );
                    }),
              ],
            ),
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
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.ativos.length,
            itemBuilder: (context, index) {
              AtivoModel ativo = controller.ativos[index];

              return Dismissible(
                key: Key(ativo.id),
                confirmDismiss: (e) async {
                  String msg = await LoadingUtil.onLoading(context, () async {
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
                child: ListTile(
                  subtitle:
                      Text("Aportado: ${ativo.totalAportado.toString()} "),
                  title: Text(ativo.papel),
                ),
              );
            }),
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
