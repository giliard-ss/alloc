import 'package:alloc/app/modules/carteira/widgets/money_text_widget.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
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
    String ultimaDataLida = "";
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: Observer(
              builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.events.length,
                  itemBuilder: (context, index) {
                    AbstractEvent event = controller.events[index];
                    if (event is AplicacaoRendaVariavel) {
                      AplicacaoRendaVariavel aplicacao = event;
                      bool createItemData =
                          ultimaDataLida != DateUtil.dateToString(aplicacao.getData());
                      ultimaDataLida = DateUtil.dateToString(aplicacao.getData());
                      return createListItem(aplicacao, createItemData);
                    }
                    return Text(DateUtil.dateToString(event.getData()));
                  },
                );
              },
            ),
          ),
        ],
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

  Widget createDataItem(DateTime data) {
    return Column(
      children: [
        Text(
          DateUtil.dateToString(data, mask: "dd"),
          style: TextStyle(fontSize: 24),
        ),
        Text(DateUtil.dateToString(data, mask: "MMM").toUpperCase()),
      ],
    );
  }

  Widget createAplicacaoDescricao(AplicacaoRendaVariavel aplicacao) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          aplicacao.qtdString + " x " + GeralUtil.doubleToMoney(aplicacao.precoUnitario).toString(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(aplicacao.tipoEvento), Text(aplicacao.tipoAtivo), Text(aplicacao.papel)],
        )
      ],
    );
  }

  Widget createAplicacaoItemComData(AplicacaoRendaVariavel aplicacao) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          leading: createDataItem(aplicacao.getData()),
          title: MoneyTextWidget(
            value: aplicacao.valor,
          ),
          subtitle: createAplicacaoDescricao(aplicacao),
          onLongPress: () {
            _showEditarDialog(aplicacao);
          },
        ),
        Divider(
          height: 3,
        )
      ],
    );
  }

  Widget createAplicacaoItem(AplicacaoRendaVariavel aplicacao) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          leading: Text(""),
          title: MoneyTextWidget(
            value: aplicacao.valor,
          ),
          subtitle: createAplicacaoDescricao(aplicacao),
          onLongPress: () {
            _showEditarDialog(aplicacao);
          },
        ),
        Divider(
          height: 3,
        )
      ],
    );
  }

  Widget createListItem(AplicacaoRendaVariavel aplicacao, bool createItemData) {
    if (!createItemData) {
      return createAplicacaoItem(aplicacao);
    }
    return createAplicacaoItemComData(aplicacao);
  }
}
