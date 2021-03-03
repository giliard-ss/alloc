import 'package:alloc/app/modules/home/pages/cotacao/cotacao_page.dart';

import 'pages/cotacao/cotacao_controller.dart';
import 'home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $CotacaoController,
        $HomeController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
        ModularRouter("/cotacao", child: (_, args) => CotacaoPage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
