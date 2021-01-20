import 'package:alloc/app/modules/carteira/controllers/sub_alocacao_controller.dart';
import 'package:alloc/app/modules/carteira/pages/sub_alocacao_page.dart';

import 'carteira_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'carteira_page.dart';

class CarteiraModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $SubAlocacaoController,
        $CarteiraController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter("/:id",
            child: (_, args) => CarteiraPage(args.params['id'])),
        ModularRouter("/sub-alocacao/:id",
            child: (_, args) => SubAlocacaoPage(args.params['id']))
      ];

  static Inject get to => Inject<CarteiraModule>.of();
}
