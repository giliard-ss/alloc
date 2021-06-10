import 'package:flutter/material.dart';

class ExtratoItemTitle extends StatelessWidget {
  String text;

  ExtratoItemTitle({this.text});

  @override
  Widget build(BuildContext context) {
    if (text == null) return Text("");

    return Text(text, style: TextStyle(color: Colors.grey[600]));
  }
}
