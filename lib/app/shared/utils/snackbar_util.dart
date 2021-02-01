import 'package:flutter/material.dart';

class SnackBarUtil {
  static void showSnackError(
      GlobalKey<ScaffoldState> scaffoldKey, String mensagem) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red[700],
      content: Text(
        mensagem,
        style: TextStyle(color: Colors.white),
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
