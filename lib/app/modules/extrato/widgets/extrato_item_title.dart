import 'package:flutter/material.dart';

class ExtratoItemTitle extends StatelessWidget {
  String text1;
  String text2;
  String text3;

  ExtratoItemTitle({this.text1, this.text2, this.text3});

  @override
  Widget build(BuildContext context) {
    int qtdTextsNotNull = _qtdTextsNotNull();

    switch (qtdTextsNotNull) {
      case 1:
        return Text(_getTextsNotNull()[0], style: TextStyle(color: Colors.grey[600]));
      case 2:
        return createRow2Columns();
      case 3:
        return createRow3Columns();
      default:
        return Text("");
    }
  }

  Widget createRow2Columns() {
    List<String> texts = _getTextsNotNull();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          texts[0],
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          texts[1],
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget createRow3Columns() {
    List<String> texts = _getTextsNotNull();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          texts[0],
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          texts[1],
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          texts[2],
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  int _qtdTextsNotNull() {
    return _getTextsNotNull().length;
  }

  List<String> _getTextsNotNull() {
    List<String> result = [];

    if (text1 != null) result.add(text1);
    if (text2 != null) result.add(text2);
    if (text3 != null) result.add(text3);
    return result;
  }
}
