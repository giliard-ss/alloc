import 'package:alloc/app/modules/carteira/widgets/circle_info_widget.dart';
import 'package:alloc/app/modules/home/widgets/title_widget.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
import 'package:flutter/material.dart';

class AtivosWidget extends StatelessWidget {
  static final double _textSize1 = 14;
  static final double _textSize2 = 12;

  List<AtivoDTO> ativos;
  Function(AtivoDTO) fncExcluir;
  Function(AtivoDTO, List<AtivoDTO>) fncExcluirSecundario;
  Function fncConfig;
  Function fncAdd;
  bool showButtonAdd;
  bool autoAlocacao;

  AtivosWidget(
      {@required this.ativos,
      this.fncExcluir,
      this.fncExcluirSecundario,
      @required this.fncConfig,
      @required this.fncAdd,
      @required this.showButtonAdd,
      @required this.autoAlocacao});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget(
          title: "Ativos",
          rightItems: [
            Visibility(
              visible: showButtonAdd,
              child: GestureDetector(
                onTap: fncAdd,
                child: Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Aplicar/Vender",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.dashboard_outlined,
              ),
              onPressed: fncConfig,
            )
          ],
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ativos.length,
            itemBuilder: (context, index) {
              AtivoDTO ativo = ativos[index];

              double totalAportadoAtual =
                  ativo.qtd.toDouble() * ativo.cotacaoModel.ultimo.toDouble();

              double rendimento =
                  totalAportadoAtual - ativo.totalAportado.toDouble();

              double variacaoPercentual = GeralUtil.variacaoPercentualDeXparaY(
                  ativo.totalAportado.toDouble(), totalAportadoAtual);

              return Dismissible(
                key: Key(ativo.id),
                confirmDismiss: (e) async {
                  String msg = await LoadingUtil.onLoading(context, () async {
                    if (fncExcluir != null) {
                      return await fncExcluir(ativo);
                    } else if (fncExcluirSecundario != null) {
                      return await fncExcluirSecundario(ativo, ativos);
                    } else {
                      return "Falha!";
                    }
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
                child: Column(
                  children: [
                    ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 0),
                      leading: CircleInfoWidget(
                          ativo.percentualNaAlocacaoString, index),
                      title: Text(
                        ativo.papel,
                        style: TextStyle(fontSize: _textSize1),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            GeralUtil.doubleToMoney(
                                ativo.cotacaoModel.ultimo.toDouble()),
                            style: TextStyle(
                                fontSize: _textSize2,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color),
                          ),
                          VariacaoPercentualWidget(
                            value: variacaoPercentual,
                          ),
                          Text(
                            GeralUtil.doubleToMoney(totalAportadoAtual,
                                leftSymbol: ""),
                            style: TextStyle(
                                fontSize: _textSize2,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color),
                          )
                        ],
                      ),
                      children: [
                        Container(
                          color: Color(0xffe7ecf4),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "Rendimento",
                              style: TextStyle(fontSize: _textSize2),
                            ),
                            trailing: Text(
                                GeralUtil.doubleToMoney(rendimento,
                                    leftSymbol: ""),
                                style: TextStyle(
                                    fontSize: _textSize2,
                                    color: rendimento < 0
                                        ? Colors.red
                                        : Colors.green)),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          title: Text(
                              "Total Aportado - ${ativo.qtd} x ${GeralUtil.doubleToMoney(
                                ativo.precoMedio,
                              )}",
                              style: TextStyle(fontSize: _textSize2)),
                          trailing: Text(
                              GeralUtil.doubleToMoney(ativo.totalAportado,
                                  leftSymbol: ""),
                              style: TextStyle(fontSize: _textSize2)),
                        ),
                        ListTile(
                          dense: true,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Alocação Configurada"),
                              Visibility(
                                  visible: ativo.alocacaoPercent == 0,
                                  child: Icon(Icons.notification_important))
                            ],
                          ),
                          trailing: Text(ativo.alocacaoPercentString + " %",
                              style: TextStyle(fontSize: _textSize2)),
                        ),
                        Visibility(
                          visible: !autoAlocacao,
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "Sugestão: " +
                                  (ativo.totalInvestir < 0
                                      ? "Vender"
                                      : "Aplicar"),
                              style: TextStyle(color: Colors.blue),
                            ),
                            trailing: Text(
                                GeralUtil.doubleToMoney(ativo.totalInvestir,
                                    leftSymbol:
                                        (ativo.totalInvestir > 0 ? "+" : "") +
                                            "R\$ "),
                                style: TextStyle(
                                    fontSize: _textSize2, color: Colors.blue)),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 5,
                    )
                  ],
                ),
              );
            }),
      ],
    );
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
}
