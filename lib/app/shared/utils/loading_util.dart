import 'package:flutter/material.dart';

class LoadingUtil {
  static Future<void> onLoading(
      BuildContext context, Future Function() function) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    function().whenComplete(() {
      Navigator.pop(context);
    });
  }

  static void start(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static void end(BuildContext context) {
    Navigator.pop(context);
  }
}
