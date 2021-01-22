import 'package:alloc/app/modules/login/cadastro/cadastro_page.dart';
import 'package:alloc/app/shared/services/iemail_service.dart';
import 'package:alloc/app/shared/services/impl/email_service.dart';

import 'cadastro/cadastro_controller.dart';
import 'login_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'login_page.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $CadastroController,
        $LoginController,
        Bind<IEmailService>((i) => EmailService()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => LoginPage()),
        ModularRouter("/cadastro", child: (_, args) => CadastroPage()),
      ];

  static Inject get to => Inject<LoginModule>.of();
}
