import 'package:alloc/app/shared/utils/loading_util.dart';
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
          TextField(
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
                labelText: "Data", border: const OutlineInputBorder()),
          ),
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
            keyboardType: TextInputType.number,
            onChanged: (text) => controller.qtd = int.parse(text),
            decoration: InputDecoration(
                labelText: "Quantidade", border: const OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (text) => controller.preco = double.parse(text),
            decoration: InputDecoration(
                labelText: "Preço", border: const OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: RaisedButton(
                  onPressed: () {},
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
}
