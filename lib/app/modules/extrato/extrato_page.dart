import 'package:alloc/app/modules/carteira/widgets/money_text_widget.dart';
import 'package:alloc/app/modules/extrato/widgets/extrato_item.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/models/evento_deposito.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'extrato_controller.dart';

class ExtratoPage extends StatefulWidget {
  final String title;
  const ExtratoPage({Key key, this.title = "Extrato"}) : super(key: key);

  @override
  _ExtratoPageState createState() => _ExtratoPageState();
}

class _ExtratoPageState extends ModularState<ExtratoPage, ExtratoController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: WidgetUtil.futureBuild(controller.init, _body),
      ),
    );
  }

  _body() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                createContent(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget createContent() {
    return Column(
      children: [
        Observer(
          builder: (_) {
            return Visibility(
              visible: controller.events.isEmpty,
              child: createAvisoEventosEmpty(),
            );
          },
        ),
        Observer(
          builder: (_) {
            return Visibility(
              visible: controller.events.isNotEmpty,
              child: createExtratoContent(),
            );
          },
        )
      ],
    );
  }

  Widget createAvisoEventosEmpty() {
    return Center(
      child: Text("Sem registros"),
    );
  }

  Widget createExtratoContent() {
    String ultimaDataLida = "";
    return Container(
      child: Observer(
        builder: (_) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.events.length,
            itemBuilder: (context, index) {
              AbstractEvent event = controller.events[index];
              bool createItemData = ultimaDataLida != DateUtil.dateToString(event.getData());
              ultimaDataLida = DateUtil.dateToString(event.getData());

              if (event is AplicacaoRendaVariavel) {
                return createAplicacaoListItem(event, createItemData);
              }
              if (event is EventoDeposito) {
                return createDepositoListItem(event, createItemData);
              }
              return Text(DateUtil.dateToString(event.getData()));
            },
          );
        },
      ),
    );
  }

  _showEditarDialog(AbstractEvent event) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Escolha a opção que deseja"),
          actions: <Widget>[
            TextButton(
              child: Text('Excluir'),
              onPressed: () async {
                String msg = await LoadingUtil.onLoading(context, () async {
                  return await controller.excluir(event);
                });
                Navigator.of(context).pop();
                if (msg != null) {
                  DialogUtil.showMessageDialog(context, msg);
                }
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget createAplicacaoDescricao(AplicacaoRendaVariavel aplicacao) {
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
              aplicacao.qtdString +
                  " x " +
                  GeralUtil.doubleToMoney(aplicacao.precoUnitario).toString(),
            ),
            MoneyTextWidget(
              color: Colors.black,
              value: aplicacao.valor,
              showSinal: false,
            )
          ],
        )
      ],
    );
  }

  Widget createDepositoDescricao(EventoDeposito deposito) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MoneyTextWidget(
              color: Colors.black,
              value: deposito.valor,
              showSinal: false,
            )
          ],
        )
      ],
    );
  }

  Widget createAplicacaoTitle(AplicacaoRendaVariavel aplicacao) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        createAplicacaoTitleText(aplicacao.tipoEvento),
        createAplicacaoTitleText(aplicacao.tipoAtivo),
        createAplicacaoTitleText(aplicacao.papel)
      ],
    );
  }

  Widget createAplicacaoTitleText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey[600]),
    );
  }

  Widget createAplicacaoListItem(AplicacaoRendaVariavel aplicacao, bool createItemData) {
    return ExtratoItem(
      data: createItemData ? aplicacao.getData() : null,
      title: createAplicacaoTitle(aplicacao),
      subtitle: createAplicacaoDescricao(aplicacao),
      onLongPress: () => _showEditarDialog(aplicacao),
    );
  }

  Widget createDepositoListItem(EventoDeposito deposito, bool createItemData) {
    return ExtratoItem(
      data: createItemData ? deposito.getData() : null,
      title: Text(deposito.getTipoEvento()),
      subtitle: createDepositoDescricao(deposito),
      onLongPress: () => _showEditarDialog(deposito),
    );
  }
}
