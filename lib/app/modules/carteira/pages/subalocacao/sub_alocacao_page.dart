import 'package:alloc/app/modules/carteira/carteira_controller.dart';

import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/modules/carteira/pages/subalocacao/sub_alocacao_controller.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
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
  Observable<List<AlocacaoDTO>> _alocacoes = Observable<List<AlocacaoDTO>>([]);
  Observable<List<AtivoModel>> _ativos = Observable<List<AtivoModel>>([]);
  Observable<List<AlocacaoDTO>> _alocAtual = Observable<List<AlocacaoDTO>>([]);

  ReactionDisposer _alocacaoReactDispose;

  @override
  void initState() {
    try {
      _loadAlocacaoAtual();
      _loadAlocacoes();
      _startCarteirasReaction();
    } catch (e) {
      LoggerUtil.error(e);
    }

    super.initState();
  }

  AlocacaoDTO get alocacaoAtual => _alocAtual.value[0];
  set alocacaoAtual(e) => _alocAtual.value = [e];

  void _loadAlocacaoAtual() {
    alocacaoAtual = _carteiraController.allAlocacoes.value
        .firstWhere((e) => e.id == widget.id);
    controller.alocacaoAtual = alocacaoAtual;
  }

  void _loadAlocacoes() {
    runInAction(() {
      _alocacoes.value = _carteiraController.allAlocacoes.value
          .where(
            (e) => e.idSuperior == widget.id,
          )
          .toList();

      if (_alocacoes.value.isEmpty) {
        _loadAtivos();
        return;
      }

      _refreshAlocacoesValues();
    });
  }

  void _loadAtivos() {
    runInAction(() {
      _ativos.value = SharedMain.ativos
          .where(
            (e) => e.superiores.contains(widget.id),
          )
          .toList();
    });
  }

  void _startCarteirasReaction() {
    if (_alocacaoReactDispose != null) {
      _alocacaoReactDispose();
    }

    _alocacaoReactDispose =
        SharedMain.createCarteirasReact((List<CarteiraDTO> carteiras) {
      _refreshAlocacoesValues();
      _loadAtivos();
      _loadAlocacaoAtual();
    });
  }

  _refreshAlocacoesValues() {
    List<AlocacaoDTO> result = [];
    for (AlocacaoDTO aloc in _alocacoes.value) {
      aloc.totalInvestir = alocacaoAtual.totalInvestir * aloc.alocacaoDouble;

      result.add(aloc);
    }
    _alocacoes.value = result;
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
        _getAtivos(),
        _getAlocacoes()
      ]),
    );
  }

  Widget getResumoAlocacaoPrincipal() {
    return Observer(
      builder: (_) {
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
                child: _getButtons(),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _getButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: _createButton(Icons.add_box_rounded, "Ativo", Colors.lightBlue,
              () {
            Modular.to.pushNamed("/carteira/ativo/${alocacaoAtual.id}");
          }),
        ),
        Flexible(
          child: _createButton(
              Icons.add_box_rounded, "Alocação", Colors.lightGreen, () {
            _showNovaAlocacaoDialog();
          }),
        ),
        Flexible(
          child: _createButton(Icons.settings, "Configurar", Colors.lightGreen,
              () {
            Modular.to.pushNamed("/carteira/config/${alocacaoAtual.id}");
          }),
        ),
      ],
    );
  }

  Widget _createButton(
      IconData icon, String text, Color color, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: color,
        width: 120,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 20,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAtivos() {
    return Observer(builder: (_) {
      return Visibility(
        //mostrar ativos se tiver no ultimo nivel, ou seja, que nao haja mais alocacoes
        visible: _ativos.value.isNotEmpty && _alocacoes.value.isEmpty,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _ativos.value.length,
            itemBuilder: (context, index) {
              AtivoModel ativo = _ativos.value[index];

              return Dismissible(
                key: Key(ativo.id),
                confirmDismiss: (e) async {
                  String msg = await LoadingUtil.onLoading(context, () async {
                    return await controller.excluir(ativo, _ativos.value);
                  });

                  if (msg == null) {
                    return true;
                  }
                  DialogUtil.showMessageDialog(context, msg);
                  return false;
                },
                background: Container(),
                secondaryBackground: _slideRightBackground(),
                direction: DismissDirection.endToStart,
                child: ListTile(
                  subtitle: Text(
                      "Aportado: ${ativo.totalAportado.toString()} aloc: ${ativo.alocacao.toString()}"),
                  title: Text(ativo.papel),
                ),
              );
            }),
      );
    });
  }

  Widget _slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget _getAlocacoes() {
    return Observer(builder: (_) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _alocacoes.value.length,
          itemBuilder: (context, index) {
            AlocacaoDTO alocacao = _alocacoes.value[index];

            return Dismissible(
              key: Key(alocacao.id),
              confirmDismiss: (e) async {
                String msg = await LoadingUtil.onLoading(context, () async {
                  return await controller.excluirAlocacao(
                      alocacao, _alocacoes.value);
                });

                if (msg == null) {
                  _loadAlocacoes();
                  //como estou chamando o _loadAlocacoes, nao preciso que a list seja reconstruida pelo efeito do Dismissible
                  return false;
                }
                DialogUtil.showMessageDialog(context, msg);
                return false;
              },
              background: Container(),
              secondaryBackground: _slideRightBackground(),
              direction: DismissDirection.endToStart,
              child: ListTile(
                onTap: () {
                  Modular.to.pushNamed("/carteira/sub-alocacao/${alocacao.id}");
                },
                subtitle: Text(
                    "Aportado: ${alocacao.totalAportado.toString()}     ${alocacao.totalInvestir < 0 ? 'Vender' : 'Investir'}: ${alocacao.totalInvestir.toString()}  aloc:${alocacao.alocacaoDouble.toString()}"),
                title: Text(alocacao.descricao),
                trailing: Text(" ${alocacao.totalAportadoAtual.toString()}"),
              ),
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
                bool ok = await LoadingUtil.onLoading(context, () {
                  return controller.salvarNovaAlocacao(_alocacoes.value);
                });
                if (ok) {
                  //

                  _loadAlocacoes();
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
