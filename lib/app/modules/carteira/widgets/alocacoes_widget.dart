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
  String title;

  AlocacoesWidget(
      {@required this.alocacoes,
      this.fncExcluir,
      this.fncExcluirSecundario,
      this.title = "Alocações da carteira",
      @required this.fncConfig});

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
                child: _createTile(alocacao, index),
              );
            }),
      ],
    );
  }

  _createTile(AlocacaoDTO alocacao, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ExpansionTile(
        title: Row(
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
        ),
        subtitle: Column(
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
                        (GeralUtil.limitaCasasDecimais(
                                alocacao.totalInvestir * -1))
                            .toString())
                    : 'Aplicar ' +
                        GeralUtil.doubleToMoney(alocacao.totalInvestir)),
                style: TextStyle(
                    color:
                        alocacao.totalInvestir < 0 ? Colors.red : Colors.green))
          ],
        ),
        children: [
          Container(
            color: Color(0xffe7ecf4),
            child: ListTile(
              dense: true,
              title: Text("Rendimento", style: TextStyle(fontSize: _textSize2)),
              trailing: Text(
                GeralUtil.doubleToMoney(alocacao.rendimento, leftSymbol: ""),
                style: TextStyle(
                    fontSize: _textSize2,
                    color: alocacao.rendimento < 0 ? Colors.red : Colors.green),
              ),
            ),
          ),
          ListTile(
            dense: true,
            title:
                Text("Total Aportado", style: TextStyle(fontSize: _textSize2)),
            trailing: Text(
                GeralUtil.doubleToMoney(alocacao.totalAportado, leftSymbol: ""),
                style: TextStyle(fontSize: _textSize2)),
          ),
          ListTile(
            dense: true,
            title: Text("Alocação Indicada",
                style: TextStyle(fontSize: _textSize2)),
            trailing: Text(alocacao.alocacaoPercentString + "%",
                style: TextStyle(fontSize: _textSize2)),
          ),
          RaisedButton.icon(
            elevation: 0,
            icon: Icon(Icons.arrow_forward_ios_outlined),
            label: Text(
              alocacao.totalInvestir < 0 ? 'Vender' : 'Aplicar',
            ),
            onPressed: () {
              Modular.to.pushNamed("/carteira/sub-alocacao/${alocacao.id}");
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  _createTile2(AlocacaoDTO alocacao, int index) {
    return ExpansionTile(
      leading: CircleInfoWidget(alocacao.percentualNaAlocacaoString, index),
      subtitle: Text(
          (alocacao.totalInvestir < 0
              ? ('Vender ' +
                  (GeralUtil.limitaCasasDecimais(alocacao.totalInvestir * -1))
                      .toString())
              : 'Investir ' + GeralUtil.doubleToMoney(alocacao.totalInvestir)),
          style: TextStyle(
              fontSize: _textSize2,
              color: alocacao.totalInvestir < 0 ? Colors.red : Colors.green)),
      title: Text(
        alocacao.descricao,
        style: TextStyle(color: Colors.grey[700], fontSize: _textSize1),
      ),
      children: [],
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
