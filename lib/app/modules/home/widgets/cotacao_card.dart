import 'package:alloc/app/modules/home/widgets/title_widget.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
import 'package:flutter/material.dart';

class CotacaoCard extends StatelessWidget {
  List<CotacaoModel> cotacoesEmAlta;
  List<CotacaoModel> cotacoesEmBaixa;
  Function onTap;
  String title;
  CotacaoModel cotacaoIndice;
  double variacaoTotal;

  CotacaoCard(
      {this.cotacoesEmAlta,
      this.cotacoesEmBaixa,
      this.onTap,
      this.title,
      this.cotacaoIndice,
      this.variacaoTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(
            title: title,
            withDivider: true,
            rightItems: [
              VariacaoPercentualWidget(
                fontSize: 16,
                withIcon: true,
                withSinal: false,
                value: variacaoTotal,
                fontWeight: FontWeight.bold,
              )
            ],
          ),
          Text(
            "Altas",
            style: TextStyle(fontSize: 16),
          ),
          _rowCotacoes(cotacoesEmAlta),
          Text(
            "Baixas",
            style: TextStyle(fontSize: 16),
          ),
          _rowCotacoes(cotacoesEmBaixa),
          RaisedButton.icon(
            elevation: 1,
            color: Colors.white,
            icon: Icon(Icons.search),
            label: Text("Ver Todos"),
            onPressed: onTap,
          )
        ],
      ),
    );
  }

  Row _rowCotacoes(List<CotacaoModel> cotacoes) {
    List<Widget> items = [];
    cotacoes.forEach((e) => items.add(itemCotacao(e.id, e.ultimo.toDouble(), e.variacaoHoje)));

    if (items.isEmpty) items = [Text("Nenhum Ativo")];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget itemCotacao(String papel, double ultimo, double variacao) {
    return Flexible(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: variacao < 0
                  ? Colors.red[200]
                  : (variacao > 0 ? Colors.green[200] : Colors.grey[300]),
              width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 80,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(papel, style: TextStyle(fontSize: 17)),
              Text(
                GeralUtil.doubleToMoney(
                  ultimo,
                ),
                style: TextStyle(fontSize: 13),
              ),
              VariacaoPercentualWidget(
                fontSize: 13,
                withIcon: true,
                withSinal: false,
                value: variacao,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resumoCotacao(String titulo, String indice, double variacaoIndice, double variacaoTotal) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(titulo, style: TextStyle(fontSize: 16)),
              VariacaoPercentualWidget(
                fontSize: 14,
                withIcon: true,
                withSinal: false,
                value: variacaoTotal,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                indice,
                style: TextStyle(fontSize: 16),
              ),
              VariacaoPercentualWidget(
                fontSize: 14,
                withIcon: true,
                withSinal: false,
                value: variacaoIndice,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
