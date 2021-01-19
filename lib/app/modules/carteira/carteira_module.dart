import 'carteira_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'carteira_page.dart';

class CarteiraModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $CarteiraController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter("/:id",
            child: (_, args) => CarteiraPage(args.params['id'])),
      ];

  static Inject get to => Inject<CarteiraModule>.of();
}
