import 'package:alloc/app/modules/carteira/widgets/circle_info_widget.dart';
import 'package:alloc/app/modules/home/widgets/title_widget.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AtivosWidget extends StatelessWidget {
  static final double _textSize1 = 14;
  static final double _textSize2 = 12;

  List<AtivoDTO> ativos;
  Function(AtivoDTO) fncExcluir;
  Function(AtivoDTO, List<AtivoDTO>) fncExcluirSecundario;
  String idAlocacao;
  bool autoAlocacao;

  AtivosWidget(
      {@required this.ativos,
      this.fncExcluir,
      this.fncExcluirSecundario,
      @required this.autoAlocacao,
      this.idAlocacao});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget(
          title: "Ativos",
        ),
        _listViewAtivos(),
        SizedBox(
          height: 25,
        ),
        _buttonAddAtivo(),
      ],
    );
  }

  Widget _listViewAtivos() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ativos.length,
        itemBuilder: (context, index) {
          AtivoDTO ativo = ativos[index];

          return Column(
            children: [
              _expansionTileAtivo(context, ativo, index),
              Divider(
                height: 5,
              )
            ],
          );
        });
  }

  Widget _expansionTileAtivo(BuildContext context, AtivoDTO ativo, int index) {
    double totalAportadoAtual = ativo.qtd.toDouble() * ativo.cotacaoModel.ultimo.toDouble();

    double rendimento = totalAportadoAtual - ativo.totalAportado.toDouble();

    double variacaoPercentual =
        GeralUtil.variacaoPercentualDeXparaY(ativo.totalAportado.toDouble(), totalAportadoAtual);

    return ExpansionTile(
      tilePadding: EdgeInsets.only(left: 0),
      leading: CircleInfoWidget(ativo.percentualNaAlocacaoString, index),
      title: Text(
        ativo.papel,
        style: TextStyle(fontSize: _textSize1),
      ),
      subtitle: _rowSubtitleAtivo(context, ativo, variacaoPercentual, totalAportadoAtual),
      children: [
        _listTileRendimento(rendimento),
        _listTileTotalAportado(ativo),
        _listTileAlocacaoConfigurada(ativo),
        _listTileSugestaoAplicarVender(ativo),
        _containerButtonsAtivo(context, ativo)
      ],
    );
  }

  Widget _rowSubtitleAtivo(
      BuildContext context, AtivoDTO ativo, double variacaoPercentual, double totalAportadoAtual) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          GeralUtil.doubleToMoney(ativo.cotacaoModel.ultimo.toDouble()),
          style:
              TextStyle(fontSize: _textSize2, color: Theme.of(context).textTheme.bodyText2.color),
        ),
        VariacaoPercentualWidget(
          value: variacaoPercentual,
        ),
        Text(
          GeralUtil.doubleToMoney(totalAportadoAtual, leftSymbol: ""),
          style:
              TextStyle(fontSize: _textSize2, color: Theme.of(context).textTheme.bodyText2.color),
        )
      ],
    );
  }

  Widget _listTileRendimento(double rendimento) {
    return Container(
      color: Color(0xffe7ecf4),
      child: ListTile(
        dense: true,
        title: Text(
          "Rendimento",
          style: TextStyle(fontSize: _textSize2),
        ),
        trailing: Text(GeralUtil.doubleToMoney(rendimento, leftSymbol: ""),
            style:
                TextStyle(fontSize: _textSize2, color: rendimento < 0 ? Colors.red : Colors.green)),
      ),
    );
  }

  Widget _listTileTotalAportado(AtivoDTO ativo) {
    return ListTile(
      dense: true,
      title: Text(
          "Total Aportado - ${ativo.qtd} x ${GeralUtil.doubleToMoney(
            ativo.precoMedio,
          )}",
          style: TextStyle(fontSize: _textSize2)),
      trailing: Text(GeralUtil.doubleToMoney(ativo.totalAportado, leftSymbol: ""),
          style: TextStyle(fontSize: _textSize2)),
    );
  }

  Widget _listTileAlocacaoConfigurada(AtivoDTO ativo) {
    return ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Alocação Configurada"),
          Visibility(visible: ativo.alocacaoPercent == 0, child: Icon(Icons.notification_important))
        ],
      ),
      trailing: Text(ativo.alocacaoPercentString + " %", style: TextStyle(fontSize: _textSize2)),
    );
  }

  Widget _listTileSugestaoAplicarVender(AtivoDTO ativo) {
    return Visibility(
      visible: !autoAlocacao,
      child: ListTile(
        dense: true,
        title: Text(
          "Sugestão: " + (ativo.totalInvestir < 0 ? "Vender" : "Aplicar"),
          style: TextStyle(color: Colors.blue),
        ),
        trailing: Text(
            GeralUtil.doubleToMoney(ativo.totalInvestir,
                leftSymbol: (ativo.totalInvestir > 0 ? "+" : "") + "R\$ "),
            style: TextStyle(fontSize: _textSize2, color: Colors.blue)),
      ),
    );
  }

  Widget _containerButtonsAtivo(BuildContext context, AtivoDTO ativo) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffe7ecf4),
      ),
      child: Row(
        children: [
          _buttonComprarMaisAtivo(ativo),
          SizedBox(
            width: 1,
            child: Container(
              color: Colors.white,
            ),
          ),
          _buttonVenderAtivo(ativo)
        ],
      ),
    );
  }

  Widget _buttonComprarMaisAtivo(AtivoDTO ativo) {
    return Flexible(
      child: RaisedButton.icon(
          elevation: 0,
          color: Color(0xffe7ecf4),
          icon: Icon(
            Icons.download_rounded,
            color: Colors.grey[600],
          ),
          label: Text(
            "Aplicar Mais",
            style: TextStyle(color: Colors.grey[600]),
          ),
          onPressed: () {
            if (idAlocacao != null)
              Modular.to
                  .pushNamed("/carteira/ativo/comprar/alocacao/${idAlocacao}/papel/${ativo.papel}");
            else
              Modular.to.pushNamed("/carteira/ativo/comprar/papel/${ativo.papel}");
          }),
    );
  }

  Widget _buttonVenderAtivo(AtivoDTO ativo) {
    return Flexible(
      child: RaisedButton.icon(
          color: Color(0xffe7ecf4),
          elevation: 0,
          icon: Icon(
            Icons.upload_rounded,
            color: Colors.grey[600],
          ),
          label: Text(
            "Vender",
            style: TextStyle(color: Colors.grey[600]),
          ),
          onPressed: () {
            Modular.to.pushNamed("/carteira/ativo/vender/papel/${ativo.papel}");
          }),
    );
  }

  Widget _buttonAddAtivo() {
    return MaterialButton(
      onPressed: () {
        if (idAlocacao != null)
          Modular.to.pushNamed("/carteira/ativo/comprar/alocacao/${idAlocacao}");
        else
          Modular.to.pushNamed("/carteira/ativo/comprar");
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: Icon(
        Icons.add,
        size: 24,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }
}
