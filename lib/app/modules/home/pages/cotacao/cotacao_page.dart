import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'cotacao_controller.dart';

class CotacaoPage extends StatefulWidget {
  final String title;
  final String tipo;
  final bool isB3;
  const CotacaoPage(this.tipo, {this.isB3 = false, key, this.title = "Cotacao"}) : super(key: key);

  @override
  _CotacaoPageState createState() => _CotacaoPageState();
}

class _CotacaoPageState extends ModularState<CotacaoPage, CotacaoController> {
  //use 'controller' variable to access controller

  @override
  void initState() {
    controller.tipo = widget.tipo;
    controller.isB3 = widget.isB3;
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
      body: WidgetUtil.futureBuild(controller.init, _body),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Observer(
              builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.cotacoes.length,
                  itemBuilder: (context, index) {
                    CotacaoModel cotacao = controller.cotacoes[index];

                    return itemCotacao(cotacao.id, cotacao.ultimo.toDouble(), cotacao.variacaoHoje);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget itemCotacao(String papel, double ultimo, double variacao) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(papel, style: TextStyle(fontSize: 16)),
                  Text(
                    GeralUtil.doubleToMoney(ultimo, leftSymbol: ""),
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
              VariacaoPercentualWidget(
                fontSize: 14,
                withIcon: true,
                withSinal: false,
                value: variacao,
              ),
            ],
          ),
          Divider(
            height: 5,
          )
        ],
      ),
    );
  }
}
