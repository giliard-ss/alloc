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
        body: WidgetUtil.futureBuild(controller.init, _body));
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(
              builder: (_) {
                return Visibility(
                  visible: controller.alocacoes.isEmpty &&
                      controller.ativos.isEmpty &&
                      controller.carteira.saldo == 0,
                  child: _contentPrimeiroDeposito(),
                );
              },
            ),
            Observer(
              builder: (_) {
                return Visibility(
                  visible: controller.alocacoes.isEmpty &&
                      controller.ativos.isEmpty &&
                      controller.carteira.saldo != 0,
                  child: _contentPrimeiraAlocAtivo(),
                );
              },
            ),
            Observer(
              builder: (_) {
                return Visibility(
                  visible: controller.alocacoes.isNotEmpty ||
                      controller.ativos.isNotEmpty,
                  child: _content(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _resumo() {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            _resumoRow("Total Depositado", controller.carteira.totalDeposito),
            Divider(
              height: 5,
            ),
            _resumoRow("Total Aplicado", controller.carteira.totalAportado),
            Divider(
              height: 5,
            ),
            _resumoRow("Saldo", controller.carteira.saldo,
                valorFW: FontWeight.bold),
          ],
        );
      },
    );
  }

  _resumoRow(String descricao, double valor, {valorFW: FontWeight.normal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(descricao),
        Text(
          GeralUtil.doubleToMoney(valor, leftSymbol: ""),
          style: TextStyle(fontWeight: valorFW),
        )
      ],
    );
  }

  _menu({excluir: true, deposito: true, saque: true}) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.title,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            PopupMenuButton(
              icon: Icon(Icons.menu),
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(
                  enabled: deposito,
                  child: Row(
                    children: [
                      Icon(Icons.upload_rounded),
                      Text("Depósito"),
                    ],
                  ),
                  value: "deposito",
                ),
                PopupMenuItem(
                    enabled: saque,
                    child: Row(
                      children: [
                        Icon(Icons.monetization_on_outlined),
                        Text("Saque"),
                      ],
                    ),
                    value: "saque"),
                PopupMenuItem(
                    enabled: excluir,
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        Text("Excluir Carteira"),
                      ],
                    ),
                    value: "excluirCarteira"),
              ],
              onSelected: (e) {
                if (e == 'excluirCarteira') {
                  _showExcluirCarteiraDialog();
                }
                if (e == 'config') {
                  Modular.to.pushNamed("/carteira/config");
                }

                switch (e) {
                  case 'excluirCarteira':
                    {
                      _showExcluirCarteiraDialog();
                    }
                    break;

                  case "deposito":
                    {
                      _showDepositoDialog();
                    }
                    break;
                  case "saque":
                    {
                      _showRetiradaDialog();
                    }
                    break;

                  default:
                    break;
                }
              },
            )
          ],
        ),
      ],
    );
  }

  _header() {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _menu(),
            SizedBox(
              height: 50,
            ),
            Text("TOTAL ATUALIZADO"),
            Text(
              GeralUtil.doubleToMoney(controller.carteira.totalAportadoAtual),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              (controller.carteira.rendimentoTotal > 0 ? '+' : '') +
                  controller.carteira.rendimentoTotalPercentString +
                  "%",
              style: TextStyle(
                color: controller.carteira.rendimentoTotal < 0
                    ? Colors.red
                    : Colors.green,
                fontSize: 16,
              ),
            )
          ],
        );
      },
    );
  }

  _contentPrimeiroDeposito() {
    return Center(
      child: Column(
        children: [
          _menu(deposito: false, saque: false),
          SizedBox(
            height: 50,
          ),
          Text(
            "Carteira Nova!",
            style: TextStyle(fontSize: 16),
          ),
          Text("Informe seu primeiro depósito:"),
          SizedBox(
            height: 20,
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (text) => controller.valorDeposito = double.parse(text),
            decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.red),
                errorText: controller.errorDialog,
                labelText: "Valor",
                border: const OutlineInputBorder()),
          ),
          RaisedButton(
            child: Text("Continuar"),
            onPressed: () async {
              bool ok = await LoadingUtil.onLoading(
                  context, controller.salvarDeposito);
            },
          )
        ],
      ),
    );
  }

  _contentPrimeiraAlocAtivo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _menu(),
        _resumo(),
        SizedBox(
          height: 50,
        ),
        Text(
          "Saldo Disponível!",
          style: TextStyle(fontSize: 16),
        ),
        Text("Escolha abaixo para incluir alocações ou ativos"),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: CustomButtonWidget(
                  icon: Icons.add_box_rounded,
                  text: "Alocação",
                  onPressed: () {
                    _showNovaAlocacaoDialog();
                  }),
            ),
            Flexible(
              child: CustomButtonWidget(
                  icon: Icons.add_chart,
                  text: "Ativo",
                  onPressed: () {
                    Modular.to.pushNamed("/carteira/ativo");
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
              visible: controller.alocacoes.isNotEmpty ||
                  controller.ativos.isNotEmpty,
              child: Column(children: [
                _header(),
                SizedBox(
                  height: 30,
                ),
                _resumo(),
                SizedBox(
                  height: 50,
                ),
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

  Widget _getAlocacoes() {
    return Observer(
      builder: (_) {
        return Visibility(
            visible: controller.alocacoes.isNotEmpty,
            child: AlocacoesWidget(
              alocacoes: controller.alocacoes,
              fncExcluir: controller.excluirAlocacao,
              fncConfig: () {
                Modular.to.pushNamed("/carteira/config");
              },
              fncAdd: _showNovaAlocacaoDialog,
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
          showButtonAdd: controller.carteira.saldo > 0,
          autoAlocacao: controller.carteira.autoAlocacao,
          fncExcluir: controller.excluir,
          fncAdd: () {
            Modular.to.pushNamed("/carteira/ativo");
          },
          fncConfig: () {
            Modular.to.pushNamed("/carteira/config");
          },
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
