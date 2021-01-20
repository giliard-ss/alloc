import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/controllers/sub_alocacao_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

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
  Observable<List<AlocacaoDTO>> alocacoes = Observable<List<AlocacaoDTO>>([]);
  AlocacaoDTO alocacaoAtual;

  ReactionDisposer _alocacaoReactDispose;

  @override
  void initState() {
    controller.id = widget.id;
    try {
      CarteiraController _carteiraController = Modular.get();
      alocacaoAtual = _carteiraController.allAlocacoes.value
          .firstWhere((e) => e.id == widget.id);

      alocacoes.value = _carteiraController.allAlocacoes.value
          .where(
            (e) => e.idSuperior == widget.id,
          )
          .toList();

      _refreshAlocacoes();
      _startCarteirasReaction();
    } catch (e) {
      LoggerUtil.error(e);
    }

    super.initState();
  }

  void _startCarteirasReaction() {
    if (_alocacaoReactDispose != null) {
      _alocacaoReactDispose();
    }

    _alocacaoReactDispose =
        SharedMain.createCarteirasReact((List<CarteiraDTO> carteiras) {
      _refreshAlocacoes();
    });
  }

  _refreshAlocacoes() async {
    List<AlocacaoDTO> result = [];
    for (AlocacaoDTO aloc in alocacoes.value) {
      aloc.totalInvestir =
          alocacaoAtual.totalInvestir * aloc.alocacao.toDouble();

      result.add(aloc);
    }
    alocacoes.value = result;
  }

  @override
  void dispose() {
    _alocacaoReactDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(alocacaoAtual.descricao),
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
          itemCount: alocacoes.value.length,
          itemBuilder: (context, index) {
            AlocacaoDTO alocacao = alocacoes.value[index];

            return ListTile(
              onTap: () {
                Modular.to.pushNamed("/carteira/sub-alocacao/${alocacao.id}");
                // Modular.to
                //     .popAndPushNamed("/carteira/sub-alocacao/${alocacao.id}");
                //Modular.to.pushReplacementNamed(
                //    "/carteira/sub-alocacao/${alocacao.id}");
              },
              subtitle: Text(
                  "Aportado: ${alocacao.totalAportado.toString()}     ${alocacao.totalInvestir < 0 ? 'Vender' : 'Investir'}: ${alocacao.totalInvestir.toString()}  "),
              title: Text(alocacao.descricao),
              trailing: Text(" ${alocacao.totalAportadoAtual.toString()}"),
            );
          });
    });
  }
}
