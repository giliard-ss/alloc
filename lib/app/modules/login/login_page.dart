import 'package:alloc/app/shared/utils/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _errorText(),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                _entrarButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _entrarButton() {
    return Container(
      color: Colors.blue,
      child: OutlineButton(
        onPressed: () async {
          LoadingUtil.start(context);
          bool goHome = await controller.entrar();
          if (goHome) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          } else {
            LoadingUtil.end(context);
          }
        },
        padding: EdgeInsets.only(left: 0),
        child: Container(
          height: 50,
          child: Row(
            children: [
              Container(
                color: Colors.white,
                child: Image(
                  width: 50,
                  height: 50,
                  image: AssetImage("assets/images/login-with-google-icon.png"),
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 2,
                color: Colors.blue[700],
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Logar com o Google",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _errorText() {
    return Observer(
      builder: (_) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible:
                  (controller.error != null && controller.error.isNotEmpty),
              child: Text(
                controller.error,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
