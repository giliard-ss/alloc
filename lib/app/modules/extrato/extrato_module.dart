import 'extrato_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'extrato_page.dart';

class ExtratoModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $ExtratoController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => ExtratoPage()),
      ];

  static Inject get to => Inject<ExtratoModule>.of();
}
