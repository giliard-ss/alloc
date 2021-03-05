import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'ativo_controller.dart';

class AtivoPage extends StatefulWidget {
  final String title;
  final String idAlocacao;
  const AtivoPage(this.idAlocacao, {Key key, this.title = "Ativo"})
      : super(key: key);

  @override
  _AtivoPageState createState() => _AtivoPageState();
}

class _AtivoPageState extends ModularState<AtivoPage, AtivoController> {
  //use 'controller' variable to access controller
  TextEditingController _controller =
      TextEditingController(text: DateUtil.dateToString(DateTime.now()));
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final _moneyController = new MoneyMaskedTextController(leftSymbol: "R\$ ");

  @override
  void initState() {
    controller.setAlocacaoAtual(widget.idAlocacao);
    super.initState();
  }

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
          _selectTipo(),
          SizedBox(
            height: 10,
          ),
          _dataTextField(),
          SizedBox(
            height: 10,
          ),
          TextField(
            textCapitalization: TextCapitalization.characters,
            onChanged: (text) => controller.papel = text.toUpperCase(),
            decoration: InputDecoration(
                labelText: "Papel", border: const OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) => controller.qtd = double.parse(text),
            decoration: InputDecoration(
                labelText: "Quantidade", border: const OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
                labelText: "Cotação", border: const OutlineInputBorder()),
            controller: _moneyController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.preco = _moneyController.numberValue;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: RaisedButton(
                  onPressed: () async {
                    bool ok =
                        await LoadingUtil.onLoading(context, controller.vender);
                    if (ok) {
                      setState(() {
                        Modular.to.pop();
                      });
                    }
                  },
                  child: Text('Vender'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: RaisedButton(
                  child: Text('Comprar'),
                  onPressed: () async {
                    bool ok = await LoadingUtil.onLoading(
                        context, controller.comprar);
                    if (ok) {
                      setState(() {
                        Modular.to.pop();
                      });
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _selectTipo() {
    return Observer(
      builder: (_) {
        return DropdownButton<String>(
          value: controller.tipo,
          icon: Icon(Icons.arrow_downward),
          isExpanded: true,
          onChanged: controller.changeTipo,
          items: <String>['ACAO', 'FII', 'ETF', 'CRIPTO', 'RF']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
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
      decoration: InputDecoration(
          labelText: "Data",
          border: const OutlineInputBorder(),
          counterText: ""),
    );
  }
}
