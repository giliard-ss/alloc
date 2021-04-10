import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'provento_controller.dart';

class ProventoPage extends StatefulWidget {
  final String title;

  const ProventoPage({Key key, this.title = "Proventos"}) : super(key: key);

  @override
  _ProventoPageState createState() => _ProventoPageState();
}

class _ProventoPageState extends ModularState<ProventoPage, ProventoController> {
  //use 'controller' variable to access controller
  TextEditingController _controller =
      TextEditingController(text: DateUtil.dateToString(DateTime.now()));
  var maskFormatter =
      new MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final _moneyController = new MoneyMaskedTextController(leftSymbol: "R\$ ");
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: _body(),
        ));
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Observer(
            builder: (_) {
              return Visibility(
                visible: controller.error.isNotEmpty,
                child: Text(
                  controller.error,
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          _dataTextField(),
          SizedBox(
            height: 10,
          ),
          Observer(
            builder: (_) {
              return TypeAheadField(
                hideOnEmpty: true,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  keyboardType: TextInputType.text,
                  onChanged: (text) => controller.setPapel(text.toUpperCase()),
                  autofocus: true,
                  decoration: InputDecoration(
                      errorText: StringUtil.isEmpty(controller.papel) || controller.papelValido
                          ? null
                          : "",
                      border: OutlineInputBorder(),
                      labelText: "Papel"),
                ),
                suggestionsCallback: (pattern) {
                  return controller.getSugestoes(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  this._typeAheadController.text = suggestion;
                  controller.papel = suggestion.toUpperCase();
                },
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) => controller.qtd = double.parse(text),
            decoration:
                InputDecoration(labelText: "Quantidade", border: const OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration:
                InputDecoration(labelText: "Valor Total", border: const OutlineInputBorder()),
            controller: _moneyController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.valorTotal = _moneyController.numberValue;
            },
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            // color: Colors.green[900],
            child: Text('Salvar', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              bool ok = await LoadingUtil.onLoading(context, controller.salvar);
              if (ok) {
                setState(() {
                  Modular.to.pop();
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget _dataTextField() {
    return TextField(
      onChanged: (e) {
        if (e.length == 10) {
          controller.data = DateUtil.StringToDate(e);
        }
      },
      controller: _controller,
      inputFormatters: [maskFormatter],
      keyboardType: TextInputType.number,
      maxLength: 10,
      decoration:
          InputDecoration(labelText: "Data", border: const OutlineInputBorder(), counterText: ""),
    );
  }
}
