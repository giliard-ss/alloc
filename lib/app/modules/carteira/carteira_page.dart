import 'package:alloc/app/modules/carteira/widgets/alocacoes_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/ativos_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/money_text_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/primeira_inclusao_widget.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'carteira_controller.dart';

class CarteiraPage extends StatefulWidget {
  final String title;
  final String carteiraId;
  const CarteiraPage(this.carteiraId, {Key key, this.title = "Carteira"}) : super(key: key);

  @override
  _CarteiraPageState createState() => _CarteiraPageState();
}

class _CarteiraPageState extends ModularState<CarteiraPage, CarteiraController> {
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
        appBar: AppBar(
          title: Text(controller.title),
          actions: [createPopMenuButton()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.upload_rounded),
              label: "Depositar",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: "Sacar"),
            BottomNavigationBarItem(
              icon: Observer(builder: (_) {
                return Icon(
                  Icons.monetization_on_sharp,
                  color: controller.existeProventosParaLancar ? Colors.green : null,
                );
              }),
              label: "Novo Provento",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: "Extrato"),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Modular.to.pushNamed("/carteira/deposito");
                break;
              case 1:
                Modular.to.pushNamed("/carteira/saque");
                break;
              case 2:
                if (controller.existeProventosParaLancar)
                  Modular.to.pushNamed("/carteira/provento");
                else
                  Modular.to.pushNamed("/carteira/provento/crud");
                break;
              case 3:
                Modular.to.pushNamed("/carteira/extrato");
                break;
            }
          },
        ),
        body: WidgetUtil.futureBuild(controller.init, _body));
  }

  createPopMenuButton() {
    return PopupMenuButton(
      icon: Icon(Icons.menu),
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(
            enabled: true,
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
      },
    );
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
                  child: PrimeiraInclusaoWidget(
                    menuWidget: Container(),
                    resumoWidget: _resumo(),
                    fncNovaAlocacao: () {
                      _showNovaAlocacaoDialog();
                    },
                    fncNovoAtivo: () {
                      Modular.to.pushNamed("/carteira/ativo/comprar");
                    },
                  ),
                );
              },
            ),
            Observer(
              builder: (_) {
                return Visibility(
                  visible: controller.alocacoes.isNotEmpty || controller.ativos.isNotEmpty,
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
    return Column(
      children: [
        _columnConta(),
        SizedBox(
          height: 20,
        ),
        _columnDesempenhoCarteira()
      ],
    );
  }

  Widget _columnConta() {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CONTA",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 5,
            ),
            _resumoRow("Total Depositado", controller.carteira.totalDeposito),
            Divider(
              height: 5,
            ),
            _resumoRow("Total Aplicado", controller.carteira.totalAportado),
            Divider(
              height: 5,
            ),
            _resumoRow("Saldo", controller.carteira.saldo, valorFW: FontWeight.bold),
          ],
        );
      },
    );
  }

  Widget _columnDesempenhoCarteira() {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DESEMPENHO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 5,
            ),
            _resumoRow("Total Proventos", 0.0,
                widgetValor: MoneyTextWidget(
                  leftSymbol: "",
                  fontSize: 14,
                  value: controller.carteira.totalProventos,
                )),
            Divider(
              height: 5,
            ),
            _resumoRow("Lucro de Vendas", 0.0,
                widgetValor: MoneyTextWidget(
                  leftSymbol: "",
                  fontSize: 14,
                  value: controller.carteira.totalLucroVendas,
                )),
            Divider(
              height: 5,
            ),
            _resumoRow("Rendimento do Total Aplicado", 0.0,
                widgetValor: MoneyTextWidget(
                  showSinal: false,
                  leftSymbol: "",
                  fontSize: 14,
                  value: controller.carteira.valorizacaoTotal,
                ),
                iconRight: _getIconVariacao(controller.carteira.valorizacaoTotal, 14)),
            Divider(
              height: 5,
            ),
            _resumoRow("Variação do Total Aplicado", 0.0,
                widgetValor: VariacaoPercentualWidget(
                  withSinal: false,
                  withIcon: true,
                  value: controller.carteira.valorizacaoTotalPercent,
                )),
          ],
        );
      },
    );
  }

  Icon _getIconVariacao(double value, double fontSize) {
    if (value == 0) return null;
    Color color = value > 0 ? Colors.green : Colors.red;
    if (value > 0)
      return Icon(
        Icons.call_made_rounded,
        size: fontSize,
        color: color,
      );
    return Icon(
      Icons.south_east_rounded,
      size: fontSize,
      color: color,
    );
  }

  _resumoRow(String descricao, double valor,
      {valorFW: FontWeight.normal, Widget widgetValor, Icon iconRight}) {
    List<Widget> items = [Text(descricao)];

    if (widgetValor == null) {
      widgetValor = Text(
        GeralUtil.doubleToMoney(valor, leftSymbol: ""),
        style: TextStyle(fontWeight: valorFW),
      );
    }

    if (iconRight != null) {
      items.add(Row(
        children: [widgetValor, iconRight],
      ));
    } else {
      items.add(widgetValor);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  _header() {
    List varicacaoHoje = controller.getVariacaoTotal();
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("VALOR APLICADO ATUALIZADO"),
            Text(
              GeralUtil.doubleToMoney(controller.carteira.totalAportadoAtual),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Variação"),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  width: 180,
                  child: MoneyTextWidget(
                    value: varicacaoHoje[0],
                  ),
                ),
                VariacaoPercentualWidget(
                  value: varicacaoHoje[1],
                  withIcon: true,
                )
              ],
            ),
          ],
        );
      },
    );
  }

  _contentPrimeiroDeposito() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            "Carteira Nova!",
            style: TextStyle(fontSize: 16),
          ),
          Text("Vamos registrar primeiro o valor de depósito destinado à aplicações"),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              Modular.to.pushNamed("/carteira/deposito");
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 24,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          )
        ],
      ),
    );
  }

  _content() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
    ]);
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
              isSubAlocacao: false,
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
          autoAlocacao: controller.carteira.autoAlocacao,
          fncExcluir: controller.excluir,
        ),
      );
    });
  }

  _showExcluirCarteiraDialog() {
    DialogUtil.showAlertDialog(context,
        title: "Excluir Carteira",
        content: Text("Tem certeza que deseja excluir esta carteira?"), onConcluir: () async {
      String msg = await LoadingUtil.onLoading(context, controller.excluirCarteira);
      if (msg != null) {
        Navigator.of(context).pop();
        DialogUtil.showMessageDialog(context, msg);
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    });
  }

  _showNovaAlocacaoDialog() {
    controller.limparErrorDialog();
    DialogUtil.showAlertDialog(context, title: "Nova Alocação", content: Observer(
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
      bool ok = await LoadingUtil.onLoading(context, controller.salvarNovaAlocacao);
      if (ok) {
        Navigator.of(context).pop();
      }
    });
  }
}
