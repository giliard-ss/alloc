import 'package:alloc/app/modules/carteira/widgets/circle_info_widget.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:flutter/material.dart';

class AtivosWidget extends StatelessWidget {
  List<AtivoDTO> ativos;
  Function(AtivoDTO) fncExcluir;
  Function(AtivoDTO, List<AtivoDTO>) fncExcluirSecundario;

  AtivosWidget(
      {@required this.ativos, this.fncExcluir, this.fncExcluirSecundario});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            "ATIVOS",
            style: TextStyle(
                color: Color(0xff103d6b),
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ativos.length,
            itemBuilder: (context, index) {
              AtivoDTO ativo = ativos[index];

              double totalAportadoAtual =
                  ativo.qtd.toInt() * ativo.ultimaCotacao.toDouble();
              String totalAportadoAtualString =
                  GeralUtil.limitaCasasDecimais(totalAportadoAtual).toString();

              double rendimento =
                  totalAportadoAtual - ativo.totalAportado.toDouble();
              String rendimentoString =
                  GeralUtil.limitaCasasDecimais(rendimento).toString();

              String rendimentoPercentString = GeralUtil.limitaCasasDecimais(
                      (rendimento * 100) / ativo.totalAportado.toDouble())
                  .toString();

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
                      leading: CircleInfoWidget(
                          ativo.percentualNaAlocacaoString, index),
                      title: Text(
                        ativo.papel,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ativo.ultimaCotacaoString,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color),
                          ),
                          Text(
                            (rendimento > 0 ? '+' : '') +
                                rendimentoPercentString +
                                "%",
                            style: TextStyle(
                                color:
                                    rendimento < 0 ? Colors.red : Colors.green),
                          ),
                          Text(
                            totalAportadoAtualString,
                            style: TextStyle(
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
                            title: Text("Rendimento"),
                            trailing: Text(rendimentoString,
                                style: TextStyle(
                                    color: rendimento < 0
                                        ? Colors.red
                                        : Colors.green)),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          title: Text("Total Aportado"),
                          trailing: Text(ativo.totalAportadoString),
                        ),
                        ListTile(
                          dense: true,
                          title: Text("Alocação Indicada"),
                          trailing: Text(ativo.alocacaoPercentString + " %"),
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
