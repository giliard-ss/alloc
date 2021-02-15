import 'package:alloc/app/modules/carteira/widgets/circle_info_widget.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AlocacoesWidget extends StatelessWidget {
  List<AlocacaoDTO> alocacoes;
  Future<String> Function(AlocacaoDTO) fncExcluir;
  Future<String> Function(AlocacaoDTO, List<AlocacaoDTO>) fncExcluirSecundario;
  String title;

  AlocacoesWidget(
      {@required this.alocacoes,
      this.fncExcluir,
      this.fncExcluirSecundario,
      this.title = "ALOCAÇÕES"});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
                color: Color(0xff103d6b),
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
        Divider(
          color: Colors.grey[300],
          height: 5,
          indent: 15,
          endIndent: 15,
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: alocacoes.length,
            itemBuilder: (context, index) {
              AlocacaoDTO alocacao = alocacoes[index];

              return Dismissible(
                key: Key(alocacao.id),
                confirmDismiss: (e) async {
                  String msg = await LoadingUtil.onLoading(context, () async {
                    if (fncExcluir != null)
                      return await fncExcluir(alocacao);
                    else if (fncExcluirSecundario != null)
                      return await fncExcluirSecundario(alocacao, alocacoes);
                    else
                      "Falha!";
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
                child: ExpansionTile(
                  leading: CircleInfoWidget(
                      alocacao.percentualNaAlocacaoString, index),
                  subtitle: Text(
                      (alocacao.totalInvestir < 0
                          ? ('Vender ' +
                              (GeralUtil.limitaCasasDecimais(
                                      alocacao.totalInvestir * -1))
                                  .toString())
                          : 'Investir ' + alocacao.totalInvestirString),
                      style: TextStyle(
                          color: alocacao.totalInvestir < 0
                              ? Colors.red
                              : Colors.green)),
                  title: Text(
                    alocacao.descricao,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  children: [
                    Container(
                      color: Color(0xffe7ecf4),
                      child: ListTile(
                        dense: true,
                        title: Row(
                          children: [
                            Text("Rendimento"),
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              (alocacao.rendimento > 0 ? '+' : '') +
                                  alocacao.rendimentoPercentString +
                                  "%",
                              style: TextStyle(
                                  color: alocacao.rendimento < 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ],
                        ),
                        trailing: Text(
                          alocacao.rendimentoString,
                          style: TextStyle(
                              color: alocacao.rendimento < 0
                                  ? Colors.red
                                  : Colors.green),
                        ),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("Total Aportado"),
                      trailing: Text(alocacao.totalAportadoString),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("Total Aportado c/ Rend."),
                      trailing: Text(alocacao.totalAportadoAtualString),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("Alocação Indicada"),
                      trailing: Text(alocacao.alocacaoPercentString + "%"),
                    ),
                    Container(
                      color: Color(0xffe7ecf4),
                      child: ListTile(
                        dense: true,
                        onTap: () {
                          Modular.to.pushNamed(
                              "/carteira/sub-alocacao/${alocacao.id}");
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              alocacao.totalInvestir < 0
                                  ? 'Vender'
                                  : 'Investir',
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
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
