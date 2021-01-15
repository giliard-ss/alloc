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
      ),
      initialRoute: '/',
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
