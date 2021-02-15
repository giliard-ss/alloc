import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/pages/subalocacao/sub_alocacao_controller.dart';
import 'package:alloc/app/modules/carteira/widgets/alocacoes_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/ativos_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/custom_button_widget.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
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

  Observable<List<AlocacaoDTO>> _alocacoes = Observable<List<AlocacaoDTO>>([]);
  Observable<List<AtivoDTO>> _ativos = Observable<List<AtivoDTO>>([]);
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
    alocacaoAtual = SharedMain.getAlocacaoById(widget.id);
    controller.alocacaoAtual = alocacaoAtual;
  }

  void _loadAlocacoes() {
    runInAction(() {
      List<AlocacaoDTO> list = SharedMain.getAlocacoesByIdSuperior(widget.id);
      list.forEach(
          (e) => e.percentualNaAlocacao = _getPercentualAtualAloc(e, list));
      list.sort((e1, e2) =>
          e2.percentualNaAlocacao.compareTo(e1.percentualNaAlocacao));
      _alocacoes.value = list;
      if (_alocacoes.value.isEmpty) {
        _loadAtivos();
        return;
      } else {}

      _refreshAlocacoesValues();
    });
  }

  void _loadAtivos() {
    runInAction(() {
      List<AtivoDTO> list = SharedMain.getAtivosByIdSuperior(widget.id);
      list.forEach(
          (e) => e.percentualNaAlocacao = _getPercentualAtualAtivo(e, list));

      list.sort((e1, e2) =>
          e2.percentualNaAlocacao.compareTo(e1.percentualNaAlocacao));
      _ativos.value = list;
    });
  }

  double _getPercentualAtualAloc(
      AlocacaoDTO aloc, List<AlocacaoDTO> alocacoes) {
    if (aloc.totalAportadoAtual == 0) return 0;
    double total = 0;
    alocacoes.forEach((e) => total = total + e.totalAportadoAtual);
    double percent = (aloc.totalAportadoAtual * 100) / total;
    return percent;
  }

  double _getPercentualAtualAtivo(AtivoDTO ativo, List<AtivoDTO> ativos) {
    if (ativo.totalAportadoAtual == 0) return 0;
    double total = 0;
    ativos.forEach((e) => total = total + e.totalAportadoAtual);
    double percent = (ativo.totalAportadoAtual * 100) / total;
    return percent;
  }

  void _startCarteirasReaction() {
    if (_alocacaoReactDispose != null) {
      _alocacaoReactDispose();
    }

    _alocacaoReactDispose = SharedMain.createCarteirasReact((e) {
      _loadAlocacaoAtual();
      _loadAlocacoes();
    });
  }

  _refreshAlocacoesValues() {
    List<AlocacaoDTO> result = [];

    for (AlocacaoDTO aloc in _alocacoes.value) {
      aloc.totalInvestir =
          (alocacaoAtual.totalAposInvestir * aloc.alocacao.toDouble()) -
              aloc.totalAportadoAtual;

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
        Container(
          //header
          padding: EdgeInsets.only(top: 20),
          height: 100,
          color: Theme.of(context).primaryColor,
          child: _header(),
        ),
        SizedBox(
          height: 20,
        ),
        ListTile(
          title: Text(
            "RESUMO",
            style: TextStyle(
                color: Color(0xff103d6b),
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
        getResumoAlocacaoPrincipal(),
        _getButtons(),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [_getAtivos(), _getAlocacoes()],
          ),
        )
      ]),
    );
  }

  _header() {
    return Observer(
      builder: (_) {
        return ListTile(
          title: Text(
            "R\$ " + alocacaoAtual.totalAportadoAtualString,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Total Atualizado",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              )),
        );
      },
    );
  }

  Widget getResumoAlocacaoPrincipal() {
    return Observer(
      builder: (_) {
        return Column(
          children: [
            ListTile(
              title: Text("Aportado"),
              trailing: Text(alocacaoAtual.totalAportadoString),
            ),
            ListTile(
              title: Text("Investir"),
              trailing: Text(alocacaoAtual.totalInvestirString),
            ),
          ],
        );
      },
    );
  }

  Widget _getButtons() {
    return Observer(
      builder: (_) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: _alocacoes.value.isEmpty,
                child: Flexible(
                  child: CustomButtonWidget(
                      icon: Icons.add_box_rounded,
                      text: "Ativo",
                      onPressed: () {
                        Modular.to
                            .pushNamed("/carteira/ativo/${alocacaoAtual.id}");
                      }),
                ),
              ),
              Visibility(
                visible: _ativos.value.isEmpty,
                child: Flexible(
                  child: CustomButtonWidget(
                      icon: Icons.add_box_rounded,
                      text: "Alocação",
                      onPressed: () {
                        _showNovaAlocacaoDialog();
                      }),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: CustomButtonWidget(
                    icon: Icons.settings,
                    text: "Configurar",
                    onPressed: () {
                      Modular.to
                          .pushNamed("/carteira/config/${alocacaoAtual.id}");
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getAtivos() {
    return Observer(builder: (_) {
      return Visibility(
        //mostrar ativos somente se nao houve subalocacoes , ou seja, se estiver no ultimo nivel
        visible: _ativos.value.isNotEmpty && _alocacoes.value.isEmpty,
        child: AtivosWidget(
          ativos: _ativos.value,
          fncExcluirSecundario: controller.excluir,
        ),
      );
    });
  }

  Widget _getAlocacoes() {
    return Observer(
      builder: (_) {
        return Visibility(
            visible: _alocacoes.value.isNotEmpty,
            child: AlocacoesWidget(
              alocacoes: _alocacoes.value,
              fncExcluirSecundario: controller.excluirAlocacao,
              title: "SUB-ALOCAÇÕES",
            ));
      },
    );
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
