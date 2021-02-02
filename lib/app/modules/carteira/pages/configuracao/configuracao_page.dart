import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'configuracao_controller.dart';

class ConfiguracaoPage extends StatefulWidget {
  final String title;
  final String superiorId;
  const ConfiguracaoPage(this.superiorId,
      {Key key, this.title = "Configuracao"})
      : super(key: key);

  @override
  _ConfiguracaoPageState createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState
    extends ModularState<ConfiguracaoPage, ConfiguracaoController> {
  //use 'controller' variable to access controller
  @override
  void initState() {
    controller.superiorId = widget.superiorId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WidgetUtil.futureBuild(controller.init, _body),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(children: [_getAtivos(), _getAlocacoes()]),
    );
  }

  Widget _getAlocacoes() {
    return Observer(
      builder: (_) {
        return Visibility(
          visible: controller.alocacoes.isNotEmpty,
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text("Alocações",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF01579B))),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: controller.alocacoes.length,
                    itemBuilder: (context, index) {
                      AlocacaoDTO alocacao = controller.alocacoes[index];

                      return ListTile(
                          onTap: () {
                            Modular.to.pushNamed(
                                "/carteira/sub-alocacao/${alocacao.id}");
                          },
                          subtitle: Text(
                              "Aportado: ${alocacao.totalAportado.toString()}     ${alocacao.totalInvestir < 0 ? 'Vender' : 'Investir'}: ${alocacao.totalInvestir.toString()}  "),
                          title: Text(alocacao.descricao),
                          trailing: Container(
                              width: 60.0,
                              child: TextField(
                                decoration: InputDecoration(suffixText: "%"),
                              )));
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getAtivos() {
    return Observer(builder: (_) {
      return Visibility(
        //mostrar ativos somente se nao houve subalocacoes , ou seja, se estiver no ultimo nivel
        visible: controller.ativos.isNotEmpty && controller.alocacoes.isEmpty,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.ativos.length,
            itemBuilder: (context, index) {
              AtivoModel ativo = controller.ativos[index];

              return ListTile(
                subtitle: Text(
                    "Aportado: ${ativo.totalAportado.toString()} aloc: ${ativo.alocacao.toString()} "),
                title: Text(ativo.papel),
              );
            }),
      );
    });
  }
}
