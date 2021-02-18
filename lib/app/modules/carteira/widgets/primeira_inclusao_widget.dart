import 'package:alloc/app/modules/carteira/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class PrimeiraInclusaoWidget extends StatelessWidget {
  Widget menuWidget;
  Widget resumoWidget;
  Function fncNovaAlocacao;
  Function fncNovoAtivo;

  PrimeiraInclusaoWidget(
      {@required this.menuWidget,
      @required this.resumoWidget,
      @required this.fncNovaAlocacao,
      @required this.fncNovoAtivo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        menuWidget,
        resumoWidget,
        SizedBox(
          height: 50,
        ),
        Text(
          "Saldo Disponível!",
          style: TextStyle(fontSize: 16),
        ),
        Text("Escolha abaixo para incluir alocações ou ativos"),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: CustomButtonWidget(
                  icon: Icons.add_box_rounded,
                  text: "Alocação",
                  onPressed: fncNovaAlocacao),
            ),
            Flexible(
              child: CustomButtonWidget(
                  icon: Icons.add_chart,
                  text: "Ativo",
                  onPressed: fncNovoAtivo),
            ),
          ],
        )
      ],
    );
  }
}
