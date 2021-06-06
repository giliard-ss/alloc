import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'deposito_controller.dart';

class DepositoPage extends StatefulWidget {
  final String title;
  final String id;
  const DepositoPage({this.id, Key key, this.title = "Depósito"}) : super(key: key);

  @override
  _DepositoPageState createState() => _DepositoPageState();
}

class _DepositoPageState extends ModularState<DepositoPage, DepositoController> {
  final _moneyController = new MoneyMaskedTextController(leftSymbol: "R\$ ");
  TextEditingController _dataController =
      TextEditingController(text: DateUtil.dateToString(DateTime.now()));
  var maskFormatter =
      new MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    controller.id = widget.id;
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
        body: WidgetUtil.futureBuild(controller.init, _body));
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Qual a data e o valor do depósito?",
          ),
          SizedBox(
            height: 50,
          ),
          _dataTextField(),
          SizedBox(
            height: 50,
          ),
          _textfieldValor(),
        ],
      ),
    );
  }

  Widget _textfieldValor() {
    if (controller.isEdicao()) _moneyController.updateValue(controller.valorDeposito);
    return Observer(
      builder: (_) {
        return TextField(
          autofocus: true,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.red),
            errorText: controller.error,
          ),
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
          ),
          controller: _moneyController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            controller.valorDeposito = _moneyController.numberValue;
          },
        );
      },
    );
  }

  Widget _dataTextField() {
    _dataController.text = DateUtil.dateToString(controller.data);
    return TextField(
      onChanged: (e) {
        if (e.length == 10) {
          controller.data = DateUtil.StringToDate(e);
        }
      },
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
      controller: _dataController,
      inputFormatters: [maskFormatter],
      keyboardType: TextInputType.number,
      maxLength: 10,
      decoration: InputDecoration(counterText: ""),
    );
  }

  Widget _buttonSalvar() {
    return FloatingActionButton.extended(
      onPressed: () async {
        bool ok = await LoadingUtil.onLoading(context, controller.salvarDeposito);
        if (ok) {
          Modular.to.pop();
        }
      },
      label: const Text('Salvar'),
      icon: const Icon(Icons.check),
    );
  }
}
