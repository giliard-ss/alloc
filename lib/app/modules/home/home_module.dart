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
        ModularRouter("/cotacao/:tipo", child: (_, args) => CotacaoPage(args.params['tipo'])),
        ModularRouter("/cotacao/b3/:tipo",
            child: (_, args) => CotacaoPage(
                  args.params['tipo'],
                  isB3: true,
                )),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
