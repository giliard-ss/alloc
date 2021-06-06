import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'configuracao_controller.dart';

class ConfiguracaoPage extends StatefulWidget {
  final String title;
  final String superiorId;
  const ConfiguracaoPage(this.superiorId, {Key key, this.title = "Configuracao"}) : super(key: key);

  @override
  _ConfiguracaoPageState createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends ModularState<ConfiguracaoPage, ConfiguracaoController> {
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
      floatingActionButton: _buttonSalvar(),
      body: WidgetUtil.futureBuild(controller.init, _body),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(children: [
        _buttonAlocacaoAutomatica(),
        _getAlocacoes(),
      ]),
    );
  }

  Widget _buttonAlocacaoAutomatica() {
    return Observer(
      builder: (_) {
        return ListTile(
          title: Text("Alocação Automática"),
          trailing: Switch(
            onChanged: (e) {
              setState(() {
                controller.changeAutoAlocacao(e);
              });
            },
            value: controller.autoAlocacao,
          ),
        );
      },
    );
  }

  Widget _buttonSalvar() {
    return FloatingActionButton.extended(
      onPressed: () async {
        String msg = await LoadingUtil.onLoading(context, () async {
          return await controller.salvar();
        });

        if (msg != null) {
          DialogUtil.showMessageDialog(context, msg, fncFechar: () {
            Modular.to.pop();
          });
        } else {
          Modular.to.pop();
        }
      },
      label: const Text('Salvar'),
      icon: const Icon(Icons.check),
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
                          fontSize: 18, fontWeight: FontWeight.bold, color: Color(0XFF01579B))),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: controller.alocacoes.length,
                    itemBuilder: (context, index) {
                      AlocacaoDTO alocacao = controller.alocacoes[index];

                      return Observer(
                        builder: (_) {
                          return ListTile(
                              title: Text(alocacao.descricao),
                              trailing:
                                  Container(width: 60.0, child: _percentualAlocWidget(alocacao)));
                        },
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _percentualAlocWidget(AlocacaoDTO alocacao) {
    if (controller.autoAlocacao) {
      return Text((alocacao.alocacaoPercent % 2 == 0
              ? alocacao.alocacaoPercent.round().toString()
              : alocacao.alocacaoPercent.toString()) +
          " %");
    }
    return _percentualAlocTextField(alocacao);
  }

  Widget _percentualAlocTextField(AlocacaoDTO alocacao) {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 4,
      initialValue: alocacao.alocacaoPercent % 2 == 0
          ? alocacao.alocacaoPercent.round().toString()
          : alocacao.alocacaoPercent.toString(),
      onChanged: (value) {
        if (value.isEmpty) value = "0";
        alocacao.alocacaoPercent = double.parse(value);
        controller.checkAlocacoesValues();
      },
      decoration: InputDecoration(
          suffix: Text("%"),
          counterText: "",
          errorText: controller.percentualRestante < 0 ? " " : null,
          hintText:
              controller.percentualRestante < 0 ? "0" : controller.percentualRestante.toString()),
    );
  }
}
