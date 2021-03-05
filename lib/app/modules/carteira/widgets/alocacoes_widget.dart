import 'package:alloc/app/modules/carteira/widgets/circle_info_widget.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/utils/dialog_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AlocacoesWidget extends StatelessWidget {
  final double _textSize1 = 17;
  final double _textSize2 = 13;
  List<AlocacaoDTO> alocacoes;
  Future<String> Function(AlocacaoDTO) fncExcluir;
  Future<String> Function(AlocacaoDTO, List<AlocacaoDTO>) fncExcluirSecundario;
  Function fncConfig;
  Function fncAdd;
  String title;

  AlocacoesWidget(
      {@required this.alocacoes,
      this.fncExcluir,
      this.fncExcluirSecundario,
      this.title = "Alocações da carteira",
      @required this.fncConfig,
      @required this.fncAdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline_sharp,
                  ),
                  onPressed: fncAdd,
                ),
                IconButton(
                  icon: Icon(
                    Icons.dashboard_outlined,
                  ),
                  onPressed: fncConfig,
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
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
                child: _createTile(context, alocacao, index),
              );
            }),
      ],
    );
  }

  _createTile(context, AlocacaoDTO alocacao, int index) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey[300],
      margin: EdgeInsets.only(bottom: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: tileExpansion(context, alocacao, index),
    );
  }

  Widget titleExpansion(AlocacaoDTO alocacao, index) {
    return Row(
      children: [
        CircleInfoWidget(alocacao.percentualNaAlocacaoString, index),
        SizedBox(
          width: 10,
        ),
        Text(
          alocacao.descricao,
          style: TextStyle(fontSize: _textSize1),
        ),
      ],
    );
  }

  Widget subtitleExpansion(context, AlocacaoDTO alocacao, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
            GeralUtil.doubleToMoney(
              alocacao.totalAportadoAtual,
            ),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text(
          (alocacao.rendimento > 0 ? '+' : '') +
              alocacao.rendimentoPercentString +
              "%",
          style: TextStyle(
              fontSize: _textSize2,
              color: alocacao.rendimento < 0 ? Colors.red : Colors.green),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
            (alocacao.totalInvestir < 0
                ? ('Vender ' +
                    (GeralUtil.doubleToMoney(alocacao.totalInvestir * -1))
                        .toString())
                : 'Aplicar ' + GeralUtil.doubleToMoney(alocacao.totalInvestir)),
            style: TextStyle(color: Colors.grey)),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Widget tileExpansion(context, AlocacaoDTO alocacao, int index) {
    return ExpansionTile(
      title: titleExpansion(alocacao, index),
      subtitle: subtitleExpansion(context, alocacao, index),
      children: [
        ListTile(
          dense: true,
          title: Text("Rendimento", style: TextStyle(fontSize: _textSize2)),
          trailing: Text(
            GeralUtil.doubleToMoney(alocacao.rendimento, leftSymbol: ""),
            style: TextStyle(
                fontSize: _textSize2,
                color: alocacao.rendimento < 0 ? Colors.red : Colors.green),
          ),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
          dense: true,
          title: Text("Total Aportado", style: TextStyle(fontSize: _textSize2)),
          trailing: Text(
              GeralUtil.doubleToMoney(alocacao.totalAportado, leftSymbol: ""),
              style: TextStyle(fontSize: _textSize2)),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
          dense: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Alocação Configurada",
                  style: TextStyle(fontSize: _textSize2)),
              Visibility(
                  visible: alocacao.alocacaoPercent == 0,
                  child: Icon(Icons.notification_important))
            ],
          ),
          trailing: Text(alocacao.alocacaoPercentString + "%",
              style: TextStyle(fontSize: _textSize2)),
        ),
        GestureDetector(
          onTap: () {
            Modular.to.pushNamed("/carteira/sub-alocacao/${alocacao.id}");
          },
          child: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xffe7ecf4),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
            child: Icon(Icons.search),
          ),
        )
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
