import 'package:alloc/app/modules/carteira/controllers/sub_alocacao_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SubAlocacaoPage extends StatefulWidget {
  final String title;
  final String id;
  const SubAlocacaoPage(this.id, {Key key, this.title = "SubAlocacao"})
      : super(key: key);

  @override
  _SubAlocacaoPageState createState() => _SubAlocacaoPageState();
}

class _SubAlocacaoPageState
    extends ModularState<SubAlocacaoPage, SubAlocacaoController> {
  //use 'controller' variable to access controller

  @override
  void initState() {
    controller.id = widget.id;
    super.initState();
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('controller.title'),
        ),
        body: WidgetUtil.futureBuild(controller.init, _body));
  }

  _body() {
    return Column(children: [
      //getResumoCarteira(),
      getAlocacoes(),
    ]);
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
