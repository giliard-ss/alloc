import 'package:alloc/app/shared/dtos/provento_dto.dart';
import 'package:alloc/app/shared/models/provento_model.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'provento_controller.dart';

class ProventoPage extends StatefulWidget {
  final String title;

  const ProventoPage({
    Key key,
    this.title = "Provento",
  }) : super(key: key);

  @override
  _ProventoPageState createState() => _ProventoPageState();
}

class _ProventoPageState extends ModularState<ProventoPage, ProventoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Modular.to.pop();
              },
            )),
        floatingActionButton: _buttonNovoProvento(),
        body: WidgetUtil.futureBuild(controller.init, () {
          return Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: _body(),
          );
        }));
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Proventos de ${DateUtil.dateToString(DateTime.now(), mask: 'MMMM')}",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Observer(
              builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.proventos.length,
                  itemBuilder: (context, index) {
                    ProventoDTO provento = controller.proventos[index];

                    return _expansionTileProvento(provento);
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _expansionTileProvento(ProventoDTO provento) {
    return ExpansionTile(
      tilePadding: EdgeInsets.only(left: 0),
      title: Text(
        "Proventos de ${provento.papel}",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      leading: Text(DateUtil.dateToString(provento.data, mask: "dd/MM")),
      trailing: Text(
        GeralUtil.doubleToMoney(provento.valorDouble),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
          "${provento.qtd.toString()} x  ${GeralUtil.doubleToMoney(provento.valorDouble)} = ${GeralUtil.doubleToMoney(provento.valorTotal)}"),
      children: [_containerButtonsProvento(provento)],
    );
  }

  Widget _containerButtonsProvento(ProventoDTO provento) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffe7ecf4),
      ),
      child: Row(
        children: [
          _buttonAlterar(),
          SizedBox(
            width: 1,
            child: Container(
              color: Colors.white,
            ),
          ),
          _buttonConfirmar(provento)
        ],
      ),
    );
  }

  Widget _buttonAlterar() {
    return Flexible(
      child: RaisedButton.icon(
          elevation: 0,
          color: Colors.blue,
          icon: Icon(Icons.edit, color: Colors.white),
          label: Text(
            "Recebi diferente",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {}),
    );
  }

  Widget _buttonConfirmar(ProventoDTO provento) {
    return Flexible(
      child: RaisedButton.icon(
          elevation: 0,
          color: Colors.green,
          icon: Icon(Icons.check, color: Colors.white),
          label: Text(
            "Recebi ",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            String error = await LoadingUtil.onLoading(context, () {
              return controller.recebi(provento);
            });
            if (error != null) DialogUtil.showMessageDialog(context, error);
          }),
    );
  }

  Widget _buttonNovoProvento() {
    return FloatingActionButton.extended(
      onPressed: () async {
        /* bool ok = await LoadingUtil.onLoading(context, controller.salvarDeposito);
        if (ok) {
          Modular.to.pop();
        }*/
      },
      label: const Text('Novo'),
      icon: const Icon(Icons.add),
    );
  }
}
