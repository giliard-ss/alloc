import 'package:alloc/app/modules/home/widgets/title_widget.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/widgets/variacao_percentual_widget.dart';
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
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(
              title: title,
              withDivider: true,
            ),
            resumoCotacao("Total", cotacaoIndice.id,
                cotacaoIndice.variacaoDouble, variacaoTotal),
            Divider(
              height: 10,
              color: Colors.grey,
            ),
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
      child: Column(
        children: [
          Row(
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
              VariacaoPercentualWidget(
                withIcon: true,
                withSinal: false,
                value: variacao,
              ),
            ],
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
              VariacaoPercentualWidget(
                withIcon: true,
                withSinal: false,
                value: variacaoTotal,
              ),
              VariacaoPercentualWidget(
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
