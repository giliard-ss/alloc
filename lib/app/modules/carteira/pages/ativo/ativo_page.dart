import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
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
  final String tipoEvento;
  final String papel;
  const AtivoPage(
      {this.idAlocacao, this.tipoEvento, this.papel, this.id, Key key, this.title = "Ativo"})
      : super(key: key);

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
  String titulo;

  @override
  void initState() {
    controller.setAlocacaoAtual(widget.idAlocacao);
    controller.setId(widget.id);
    controller.papel = widget.papel;
    if (widget.tipoEvento == TipoEvento.APLICACAO.code)
      titulo = "Aplicação";
    else if (widget.tipoEvento == TipoEvento.VENDA.code)
      titulo = "Venda";
    else
      titulo = widget.title;

    super.initState();
  }

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
        floatingActionButton: _buttonSalvar(),
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
    _papelController.text = controller.papel;
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _textError(),
          SizedBox(
            height: 20,
          ),
          _dataTextField(),
          SizedBox(
            height: 10,
          ),
          _textFieldPapel(),
          SizedBox(
            height: 10,
          ),
          _textFieldQuantidade(),
          SizedBox(
            height: 10,
          ),
          _textFieldCotacao(),
        ],
      ),
    );
  }

  Widget _textError() {
    return Observer(
      builder: (_) {
        return Visibility(
          visible: controller.error.isNotEmpty,
          child: Text(
            controller.error,
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  Widget _textFieldPapel() {
    return Observer(
      builder: (_) {
        return TypeAheadField(
          hideOnEmpty: true,
          textFieldConfiguration: TextFieldConfiguration(
            controller: _papelController,
            keyboardType: TextInputType.text,
            onChanged: (text) => controller.setPapel(text.toUpperCase()),
            autofocus: controller.papel == null,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
                errorText:
                    StringUtil.isEmpty(controller.papel) || controller.papelValido ? null : "",
                labelStyle: TextStyle(fontSize: 16),
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
    );
  }

  Widget _textFieldQuantidade() {
    return TextField(
      controller: _qtdController,
      autofocus: widget.tipoEvento != null && widget.papel != null,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (text) => controller.qtd = double.parse(text),
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(labelText: "Quantidade", labelStyle: TextStyle(fontSize: 16)),
    );
  }

  Widget _textFieldCotacao() {
    return TextField(
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(labelText: "Cotação", labelStyle: TextStyle(fontSize: 16)),
      controller: _cotacaoController,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        controller.preco = _cotacaoController.numberValue;
      },
    );
  }

  Widget _buttonSalvar() {
    return FloatingActionButton.extended(
      onPressed: () async {
        bool ok;
        if (controller.isEdicao()) {
          ok = await LoadingUtil.onLoading(context, controller.salvar);
        } else if (widget.tipoEvento == TipoEvento.VENDA.code) {
          ok = await LoadingUtil.onLoading(context, controller.vender);
        } else if (widget.tipoEvento == TipoEvento.APLICACAO.code) {
          ok = await LoadingUtil.onLoading(context, controller.comprar);
        }

        if (ok) {
          setState(() {
            Modular.to.pop();
          });
        }
      },
      label: const Text('Salvar'),
      icon: const Icon(Icons.check),
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
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
      decoration:
          InputDecoration(labelText: "Data", counterText: "", labelStyle: TextStyle(fontSize: 16)),
    );
  }
}
