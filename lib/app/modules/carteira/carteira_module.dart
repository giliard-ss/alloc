import 'package:alloc/app/modules/carteira/pages/ativo/ativo_page.dart';
import 'package:alloc/app/modules/carteira/pages/subalocacao/sub_alocacao_controller.dart';
import 'package:alloc/app/modules/carteira/pages/subalocacao/sub_alocacao_page.dart';
import 'pages/ativo/ativo_controller.dart';
import 'carteira_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'carteira_page.dart';

class CarteiraModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $AtivoController,
        $SubAlocacaoController,
        $CarteiraController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter("/:id",
            child: (_, args) => CarteiraPage(args.params['id'])),
        ModularRouter("/sub-alocacao/:id",
            child: (_, args) => SubAlocacaoPage(args.params['id'])),
        ModularRouter("/ativo/:idAlocacao",
            child: (_, args) => AtivoPage(args.params['idAlocacao']))
      ];

  static Inject get to => Inject<CarteiraModule>.of();
}
