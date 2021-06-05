import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'ativo_controller.dart';

class AtivoPage extends StatefulWidget {
  final String title;
  final String idAlocacao;
  final String id;
  const AtivoPage(this.idAlocacao, {this.id, Key key, this.title = "Ativo"}) : super(key: key);

  @override
  _AtivoPageState createState() => _AtivoPageState();
}

class _AtivoPageState extends ModularState<AtivoPage, AtivoController> {
  //use 'controller' variable to access controller
  TextEditingController _dataController = TextEditingController();
  var maskFormatter =
      new MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final _cotacaoController = new MoneyMaskedTextController(leftSymbol: "R\$ ");
  final TextEditingController _papelController = TextEditingController();
  final TextEditingController _qtdController = TextEditingController();

  @override
  void initState() {
    controller.setAlocacaoAtual(widget.idAlocacao);
    controller.setId(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: WidgetUtil.futureBuild(controller.init, () {
          _preencherCampos();

          return Container(
            padding: EdgeInsets.all(10),
            child: _body(),
          );
        }));
  }

  _preencherCampos() {
    if (controller.isEdicao()) {
      _papelController.text = controller.papel;
      _cotacaoController.updateValue(controller.preco);
      _qtdController.text =
          controller.qtd % 1 == 0 ? controller.qtd.round().toString() : controller.qtd.toString();
      _dataController.text = DateUtil.dateToString(controller.data);
    } else {
      _dataController.text = DateUtil.dateToString(DateTime.now());
    }
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
                  controller: _papelController,
                  keyboardType: TextInputType.text,
                  onChanged: (text) => controller.setPapel(text.toUpperCase()),
                  autofocus: !controller.isEdicao(),
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
                  this._papelController.text = suggestion;
                  controller.papel = suggestion.toUpperCase();
                },
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _qtdController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) => controller.qtd = double.parse(text),
            decoration:
                InputDecoration(labelText: "Quantidade", border: const OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Cotação", border: const OutlineInputBorder()),
            controller: _cotacaoController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.preco = _cotacaoController.numberValue;
            },
          ),
          SizedBox(
            height: 10,
          ),
          _buttons()
        ],
      ),
    );
  }

  Widget _buttons() {
    if (controller.isEdicao()) {
      return _buttonSalvar();
    } else {
      return Row(
        children: [
          _buttonVender(),
          SizedBox(
            width: 10,
          ),
          _buttonComprar()
        ],
      );
    }
  }

  Widget _buttonSalvar() {
    return RaisedButton(
      color: Colors.green[900],
      child: Text('Salvar', style: TextStyle(color: Colors.white)),
      onPressed: () async {
        bool ok = await LoadingUtil.onLoading(context, controller.salvar);
        if (ok) {
          setState(() {
            Modular.to.pop();
          });
        }
      },
    );
  }

  Widget _buttonComprar() {
    return Flexible(
      child: RaisedButton(
        color: Colors.green[900],
        child: Text('Comprar', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          bool ok = await LoadingUtil.onLoading(context, controller.comprar);
          if (ok) {
            setState(() {
              Modular.to.pop();
            });
          }
        },
      ),
    );
  }

  Widget _buttonVender() {
    return Flexible(
      child: RaisedButton(
        color: Colors.red[900],
        onPressed: () async {
          bool ok = await LoadingUtil.onLoading(context, controller.vender);
          if (ok) {
            setState(() {
              Modular.to.pop();
            });
          }
        },
        child: Text(
          'Vender',
          style: TextStyle(color: Colors.white),
        ),
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
      controller: _dataController,
      inputFormatters: [maskFormatter],
      keyboardType: TextInputType.number,
      maxLength: 10,
      decoration:
          InputDecoration(labelText: "Data", border: const OutlineInputBorder(), counterText: ""),
    );
  }
}
