import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:flutter/material.dart';

class CotacaoCard extends StatelessWidget {
  List<AtivoDTO> ativos;
  Function onTap;
  String title;
  CotacaoModel cotacaoIndice;
  double variacaoTotal;

  CotacaoCard(
      {this.ativos,
      this.onTap,
      this.title,
      this.cotacaoIndice,
      this.variacaoTotal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            resumoCotacao("Total", cotacaoIndice.id,
                cotacaoIndice.variacaoDouble, variacaoTotal),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ativos.length,
              itemBuilder: (context, index) {
                AtivoDTO ativo = ativos[index];
                return itemCotacao(
                    ativo.papel,
                    ativo.cotacaoModel.ultimo.toDouble(),
                    ativo.cotacaoModel.variacaoDouble);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget itemCotacao(String papel, double ultimo, double variacao) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(papel, style: TextStyle(fontSize: 13)),
              Text(
                GeralUtil.doubleToMoney(ultimo, leftSymbol: ""),
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          Text(
            (variacao > 0 ? "+" : "") + variacao.toString() + "%",
            style: TextStyle(color: variacao > 0 ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }

  Widget resumoCotacao(String titulo, String indice, double variacaoIndice,
      double variacaoTotal) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: TextStyle(fontSize: 13)),
              Text(
                indice,
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (variacaoTotal > 0 ? "+" : "") + variacaoTotal.toString() + "%",
                style: TextStyle(
                    color: variacaoTotal > 0 ? Colors.green : Colors.red,
                    fontSize: 13),
              ),
              Text(
                (variacaoIndice > 0 ? "+" : "") +
                    variacaoIndice.toString() +
                    "%",
                style: TextStyle(
                    color: variacaoIndice > 0 ? Colors.green : Colors.red,
                    fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
