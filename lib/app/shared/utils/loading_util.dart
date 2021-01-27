import 'package:flutter/material.dart';

class LoadingUtil {
  static Future<dynamic> onLoading(
      BuildContext context, Future<dynamic> Function() function) async {
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

    dynamic result = await function();
    Navigator.of(context).pop();
    return result;
  }

  static Future<void> onLoadingVoid(
      BuildContext context, Future<void> Function() function) async {
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

    await function();
    Navigator.of(context).pop();
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
