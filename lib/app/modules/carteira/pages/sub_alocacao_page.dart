import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/controllers/sub_alocacao_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
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
  CarteiraController _carteiraController = Modular.get();
  Observable<List<AlocacaoDTO>> alocacoes = Observable<List<AlocacaoDTO>>([]);
  AlocacaoDTO alocacaoAtual;

  ReactionDisposer _alocacaoReactDispose;

  @override
  void initState() {
    try {
      alocacaoAtual = _carteiraController.allAlocacoes.value
          .firstWhere((e) => e.id == widget.id);
      controller.alocacaoAtual = alocacaoAtual;

      _loadAlocacoes();
      _startCarteirasReaction();
    } catch (e) {
      LoggerUtil.error(e);
    }

    super.initState();
  }

  void _loadAlocacoes() {
    runInAction(() {
      alocacoes.value = _carteiraController.allAlocacoes.value
          .where(
            (e) => e.idSuperior == widget.id,
          )
          .toList();
      _refreshAlocacoesValues();
    });
  }

  void _startCarteirasReaction() {
    if (_alocacaoReactDispose != null) {
      _alocacaoReactDispose();
    }

    _alocacaoReactDispose =
        SharedMain.createCarteirasReact((List<CarteiraDTO> carteiras) {
      _refreshAlocacoesValues();
    });
  }

  _refreshAlocacoesValues() {
    List<AlocacaoDTO> result = [];
    for (AlocacaoDTO aloc in alocacoes.value) {
      aloc.totalInvestir = alocacaoAtual.totalInvestir * aloc.alocacaoDouble;

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
    return SingleChildScrollView(
      child: Column(children: [
        getResumoAlocacaoPrincipal(),
        getAlocacoes(),
      ]),
    );
  }

  Widget getResumoAlocacaoPrincipal() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("Aportado"),
            trailing: Text(alocacaoAtual.totalAportado.toString()),
          ),
          ListTile(
            title: Text("Investir"),
            trailing: Text(alocacaoAtual.totalInvestir.toString()),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Flexible(
                  child: RaisedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: Text("Ativo"),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RaisedButton.icon(
                    onPressed: () {
                      _showNovaAlocacaoDialog();
                    },
                    icon: Icon(Icons.add),
                    label: Text("Alocação"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getAlocacoes() {
    return Observer(builder: (_) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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

  _showNovaAlocacaoDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nova Alocação'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Observer(
                  builder: (_) {
                    return TextField(
                      onChanged: (text) => controller.novaAlocacaoDesc = text,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText: controller.novaAlocacaoError,
                          labelText: "Título",
                          border: const OutlineInputBorder()),
                    );
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text("Concluir"),
              onPressed: () async {
                bool ok = await LoadingUtil.onLoading(
                    context, controller.salvarNovaAlocacao);
                if (ok) {
                  //
                  setState(() {
                    _loadAlocacoes();
                    Navigator.of(context).pop();
                  });
                }
              },
            )
          ],
        );
      },
    );
  }
}
