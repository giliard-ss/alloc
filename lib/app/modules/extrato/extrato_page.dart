import 'package:alloc/app/modules/carteira/widgets/money_text_widget.dart';
import 'package:alloc/app/modules/extrato/dtos/extrato_resumo_dto.dart';
import 'package:alloc/app/modules/extrato/widgets/extrato_item.dart';
import 'package:alloc/app/modules/extrato/widgets/extrato_item_descricao.dart';
import 'package:alloc/app/modules/extrato/widgets/extrato_item_title.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/models/evento_deposito.dart';
import 'package:alloc/app/shared/models/evento_provento.dart';
import 'package:alloc/app/shared/models/evento_saque.dart';
import 'package:alloc/app/shared/models/evento_venda_renda_variavel.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Modular.to.pop();
          },
        ),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: WidgetUtil.futureBuild(() async {
          await controller.init();
        }, _body),
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
        createDataSelect(),
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

  Widget createDataSelect() {
    return Observer(
      builder: (_) {
        return RaisedButton.icon(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          elevation: 0,
          icon: Icon(Icons.calendar_today),
          color: Colors.white,
          label: Text(
            DateUtil.dateToString(controller.mesAno, mask: "MMMM/y").toUpperCase(),
          ),
          onPressed: () {
            showMonthPicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              initialDate: controller.mesAno,
              locale: Locale("pt"),
            ).then((DateTime date) {
              if (date != null) {
                LoadingUtil.onLoading(context, () {
                  return controller.selectMesAno(date);
                });
              }
            });
          },
        );
      },
    );
  }

  Widget createAvisoEventosEmpty() {
    return Center(
      child: Text("Sem registros"),
    );
  }

  Widget createExtratoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        createExtratoResumo(),
        SizedBox(
          height: 45,
        ),
        Text(
          "Lançamentos",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 20,
        ),
        createExtratoEvents()
      ],
    );
  }

  Widget createExtratoResumo() {
    return Observer(
      builder: (_) {
        return Container(
          color: Colors.white,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.resumo.length,
              itemBuilder: (context, index) {
                ExtratoResumoDTO resumo = controller.resumo[index];
                return ListTile(
                  dense: true,
                  selected: controller.tipoEvento != null,
                  title: Text(resumo.descricao),
                  onTap: () {
                    LoadingUtil.onLoading(context, () {
                      return controller.selectTipoEvento(resumo.tipoEvento);
                    });
                  },
                  trailing: Text(GeralUtil.doubleToMoney(resumo.valor)),
                );
              }),
        );
      },
    );
  }

  Widget createExtratoEvents() {
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

              if (event is VendaRendaVariavelEvent) {
                return createVendaListItem(event, createItemData);
              }

              if (event is EventoDeposito) {
                return createDepositoListItem(event, createItemData);
              }
              if (event is EventoSaque) {
                return createSaqueListItem(event, createItemData);
              }

              if (event is EventoProvento) {
                return createProventoListItem(event, createItemData);
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
            Visibility(
              visible: controller.isPermiteEdicao(event),
              child: TextButton(
                child: Text('Editar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.editarEvent(event);
                },
              ),
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

  Widget createDescricaoItemApenasValor(double valor) {
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
              value: valor,
              showSinal: false,
            )
          ],
        )
      ],
    );
  }

  Widget createAplicacaoListItem(AplicacaoRendaVariavel aplicacao, bool createItemData) {
    return ExtratoItem(
      data: createItemData ? aplicacao.getData() : null,
      title: ExtratoItemTitle(
        text: TipoEvento(aplicacao.tipoEvento).descricao +
            " em " +
            TipoAtivo(aplicacao.tipoAtivo).descricao +
            " " +
            aplicacao.papel,
      ),
      subtitle: ExtratoItemSubtitle(
        text: aplicacao.qtdString +
            " x " +
            GeralUtil.doubleToMoney(aplicacao.precoUnitario).toString(),
        valor: aplicacao.valor,
      ),
      onLongPress: () => _showEditarDialog(aplicacao),
    );
  }

  Widget createVendaListItem(VendaRendaVariavelEvent venda, bool createItemData) {
    return ExtratoItem(
      data: createItemData ? venda.getData() : null,
      title: ExtratoItemTitle(
        text: TipoEvento(venda.tipoEvento).descricao +
            " de " +
            TipoAtivo(venda.tipoAtivo).descricao +
            " " +
            venda.papel,
      ),
      subtitle: ExtratoItemSubtitle(
        text: venda.qtdString + " x " + GeralUtil.doubleToMoney(venda.precoUnitario).toString(),
        valor: venda.valor,
      ),
      onLongPress: () => _showEditarDialog(venda),
    );
  }

  Widget createProventoListItem(EventoProvento provento, bool createItemData) {
    return ExtratoItem(
      data: createItemData ? provento.getData() : null,
      title: ExtratoItemTitle(
        text: TipoEvento(provento.tipoEvento).descricao +
            " de " +
            TipoAtivo(provento.tipoAtivo).descricao +
            " " +
            provento.papel,
      ),
      subtitle: ExtratoItemSubtitle(
        text:
            provento.qtdString + " x " + GeralUtil.doubleToMoney(provento.precoUnitario).toString(),
        valor: provento.valor,
      ),
      onLongPress: () => _showEditarDialog(provento),
    );
  }

  Widget createDepositoListItem(EventoDeposito deposito, bool createItemData) {
    return ExtratoItem(
      data: createItemData ? deposito.getData() : null,
      title: ExtratoItemTitle(
        text: TipoEvento(deposito.tipoEvento).descricao,
      ),
      subtitle: createDescricaoItemApenasValor(deposito.valor),
      onLongPress: () => _showEditarDialog(deposito),
    );
  }

  Widget createSaqueListItem(EventoSaque saque, bool createItemData) {
    return ExtratoItem(
      data: createItemData ? saque.getData() : null,
      title: ExtratoItemTitle(
        text: TipoEvento(saque.tipoEvento).descricao,
      ),
      subtitle: createDescricaoItemApenasValor(saque.valor),
      onLongPress: () => _showEditarDialog(saque),
    );
  }
}
