import 'package:alloc/app/modules/carteira/widgets/money_text_widget.dart';
import 'package:flutter/material.dart';

class ExtratoItemSubtitle extends StatelessWidget {
  String text;
  double valor;
  ExtratoItemSubtitle({this.text = "", this.valor = 0.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            MoneyTextWidget(
              color: Colors.black,
              value: valor,
              showSinal: false,
            )
          ],
        )
      ],
    );
  }
}
