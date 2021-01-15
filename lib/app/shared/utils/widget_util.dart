import 'package:flutter/material.dart';

class WidgetUtil {
  static Widget futureBuild(future, Function func) {
    return FutureBuilder(
        future: future(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Icon(Icons.error_outline, color: Colors.red, size: 60));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return func();
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
