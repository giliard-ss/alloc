import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/pages/subalocacao/sub_alocacao_controller.dart';
import 'package:alloc/app/modules/carteira/widgets/alocacoes_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/ativos_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/money_text_widget.dart';
import 'package:alloc/app/modules/carteira/widgets/primeira_inclusao_widget.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class SubAlocacaoPage extends StatefulWidget {
  final String title;
  final String id;
  const SubAlocacaoPage(this.id, {Key key, this.title = "SubAlocacao"}) : super(key: key);

  @override
  _SubAlocacaoPageState createState() => _SubAlocacaoPageState();
}

class _SubAlocacaoPageState extends ModularState<SubAlocacaoPage, SubAlocacaoController> {
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
    } catch (e, stacktrace) {
      LoggerUtil.error(e);
      print(stacktrace);
    }

    super.initState();
  }

  AlocacaoDTO get alocacaoAtual => _alocAtual.value[0];
  set alocacaoAtual(e) => _alocAtual.value = [e];

  void _loadAlocacaoAtual() {
    alocacaoAtual = AppCore.getAlocacaoById(widget.id);
    controller.alocacaoAtual = alocacaoAtual;
  }

  void _loadAlocacoes() {
    runInAction(() {
      List<AlocacaoDTO> list = AppCore.getAlocacoesByIdSuperior(widget.id);
      list.forEach((e) => e.percentualNaAlocacao = _getPercentualAtualAloc(e, list));
      list.sort((e1, e2) => e2.percentualNaAlocacao.compareTo(e1.percentualNaAlocacao));
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
      List<AtivoDTO> list = AppCore.getAtivosByIdSuperior(widget.id);
      list.forEach((e) {
        e.percentualNaAlocacao = _getPercentualAtualAtivo(e, list);

        double totalAposAporte = alocacaoAtual.totalInvestir + alocacaoAtual.totalAportadoAtual;

        double totalIdealAtivo = totalAposAporte * e.alocacaoDouble;

        e.totalInvestir = totalIdealAtivo - e.totalAportadoAtual;
      });

      list.sort((e1, e2) => e2.percentualNaAlocacao.compareTo(e1.percentualNaAlocacao));
      _ativos.value = list;
    });
  }

  double _getPercentualAtualAloc(AlocacaoDTO aloc, List<AlocacaoDTO> alocacoes) {
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

    _alocacaoReactDispose = AppCore.createCarteirasReact((e) {
      _loadAlocacaoAtual();
      _loadAlocacoes();
    });
  }

  _refreshAlocacoesValues() {
    List<AlocacaoDTO> result = [];

    for (AlocacaoDTO aloc in _alocacoes.value) {
      aloc.totalInvestir =
          (alocacaoAtual.totalAposInvestir * aloc.alocacao.toDouble()) - aloc.totalAportadoAtual;

      result.add(aloc);
    }
    _alocacoes.value = result;
  }

  @override
  void dispose() {
    _alocacaoReactDispose();
    super.dispose();
  }

  Future<bool> _requestPop() async {
    ///necessario esse tratamento pois é necessario reconstruir a tela senão a alocacaoAtual vai
    ///ser incoerente, referenciando àquela que foi fechada.
    if (alocacaoAtual.idSuperior != null) {
      Modular.to.pushReplacementNamed("/carteira/sub-alocacao/${alocacaoAtual.idSuperior}");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(alocacaoAtual.descricao),
          ),
          body: WidgetUtil.futureBuild(controller.init, _body)),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _header(),
          getResumoAlocacaoPrincipal(),
          SizedBox(
            height: 50,
          ),
          Observer(
            builder: (_) {
              return Visibility(
                visible: _alocacoes.value.isEmpty && _ativos.value.isEmpty,
                child: PrimeiraInclusaoWidget(
                  menuWidget: Container(),
                  resumoWidget: Container(),
                  fncNovaAlocacao: _showNovaAlocacaoDialog,
                  fncNovoAtivo: () {
                    Modular.to.pushNamed("/carteira/ativo/${alocacaoAtual.id}");
                  },
                ),
              );
            },
          ),
          Observer(
            builder: (_) {
              return Visibility(
                visible: _alocacoes.value.isNotEmpty || _ativos.value.isNotEmpty,
                child: _content(),
              );
            },
          ),
        ]),
      ),
    );
  }

  _content() {
    return Column(
      children: [_getAtivos(), _getAlocacoes()],
    );
  }

  _header() {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("VALOR APLICADO ATUALIZADO"),
            Text(
              GeralUtil.doubleToMoney(alocacaoAtual.totalAportadoAtual),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  width: 180,
                  child: Text("Rendimento Total"),
                ),
                Text("Variação Total")
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  width: 180,
                  child: MoneyTextWidget(value: alocacaoAtual.rendimento),
                ),
                VariacaoPercentualWidget(
                  value: alocacaoAtual.rendimentoPercent,
                )
              ],
            )
          ],
        );
      },
    );
  }

  _resumoRow(String descricao, double valor, {valorFW: FontWeight.normal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(descricao),
        Text(
          GeralUtil.doubleToMoney(valor, leftSymbol: ""),
          style: TextStyle(fontWeight: valorFW),
        )
      ],
    );
  }

  Widget getResumoAlocacaoPrincipal() {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            _resumoRow("Total Aplicado", alocacaoAtual.totalAportado),
            Divider(
              height: 5,
            ),
            _resumoRow("Saldo", alocacaoAtual.totalInvestir, valorFW: FontWeight.bold),
          ],
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
          autoAlocacao: alocacaoAtual.autoAlocacao,
          fncExcluirSecundario: controller.excluir,
          fncAdd: () {
            Modular.to.pushNamed("/carteira/ativo/${alocacaoAtual.id}");
          },
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
              fncConfig: () {
                Modular.to.pushNamed("/carteira/config/${alocacaoAtual.id}");
              },
              fncAdd: _showNovaAlocacaoDialog,
              title: "Sub-Alocações",
              isSubAlocacao: true,
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
