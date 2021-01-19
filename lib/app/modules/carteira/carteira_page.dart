import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'carteira_controller.dart';

class CarteiraPage extends StatefulWidget {
  final String title;
  final String carteiraId;
  const CarteiraPage(this.carteiraId, {Key key, this.title = "Carteira"})
      : super(key: key);

  @override
  _CarteiraPageState createState() => _CarteiraPageState();
}

class _CarteiraPageState
    extends ModularState<CarteiraPage, CarteiraController> {
  //use 'controller' variable to access controller

  @override
  void initState() {
    controller.setCarteira(widget.carteiraId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
        ),
        body: WidgetUtil.futureBuild(controller.init, _body));
  }

  _body() {
    return Column(children: [
      getResumoCarteira(),
      getAlocacoes(),
    ]);
  }

  Widget getResumoCarteira() {
    return Card(
      child: Column(
        children: [
          Text('Aportado: ${controller.carteira.totalAportado}'),
          Text('Saldo: ${controller.carteira.getSaldo()}'),
        ],
      ),
    );
  }

  Widget getAlocacoes() {
    return Observer(builder: (_) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: controller.alocacoes.length,
          itemBuilder: (context, index) {
            AlocacaoDTO alocacao = controller.alocacoes[index];

            return ListTile(
              onTap: () {},
              subtitle: Text(
                  "Aportado: ${alocacao.totalAportado.toString()}     ${alocacao.totalInvestir < 0 ? 'Vender' : 'Investir'}: ${alocacao.totalInvestir.toString()}  "),
              title: Text(alocacao.descricao),
              trailing: Text(" ${alocacao.totalAportadoAtual.toString()}"),
            );
          });
    });
  }
}
