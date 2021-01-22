import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_core/firebase_core.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtil.futureBuild(_init, _body);
  }

  Future<void> _init() async {
    await Firebase.initializeApp();
  }

  _body() {
    return MaterialApp(
      navigatorKey: Modular.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Slidy',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
            minWidth: double.infinity,
          )),
      initialRoute: '/',
      onGenerateRoute: Modular.generateRoute,
      builder: (BuildContext context, Widget widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return buildError(context, errorDetails);
        };

        return widget;
      },
    );
  }

  Widget buildError(BuildContext context, FlutterErrorDetails error) {
    return Scaffold(
      body: Center(
        child: Text(
          "Error appeared.",
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}
