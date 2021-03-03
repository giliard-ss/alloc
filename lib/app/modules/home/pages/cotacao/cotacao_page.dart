import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'cotacao_controller.dart';

class CotacaoPage extends StatefulWidget {
  final String title;
  const CotacaoPage({Key key, this.title = "Cotacao"}) : super(key: key);

  @override
  _CotacaoPageState createState() => _CotacaoPageState();
}

class _CotacaoPageState extends ModularState<CotacaoPage, CotacaoController> {
  //use 'controller' variable to access controller

  @override
  void initState() {
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ações e ETFs",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Card(
            child: Observer(
              builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.acoes.length,
                  itemBuilder: (context, index) {
                    AtivoDTO ativo = controller.acoes[index];

                    return ListTile(
                      dense: true,
                      leading:
                          Text(ativo.papel, style: TextStyle(fontSize: 13)),
                      title: Center(
                        child: Text(
                          (ativo.cotacaoModel.variacaoDouble > 0 ? "+" : "") +
                              ativo.cotacaoModel.variacaoDouble.toString() +
                              "%",
                          style: TextStyle(
                              color: ativo.cotacaoModel.variacaoDouble > 0
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ),
                      trailing: Text(
                        GeralUtil.doubleToMoney(ativo.cotacaoModel.ultimo,
                            leftSymbol: ""),
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
