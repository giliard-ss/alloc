import 'package:alloc/app/modules/carteira/carteira_module.dart';
import 'package:alloc/app/shared/repositories/ialocacao_repository.dart';
import 'package:alloc/app/shared/repositories/iativo_repository.dart';
import 'package:alloc/app/shared/repositories/icarteira_repository.dart';
import 'package:alloc/app/shared/repositories/impl/alocacao_repository.dart';
import 'package:alloc/app/shared/repositories/impl/ativo_repository.dart';
import 'package:alloc/app/shared/repositories/impl/carteira_repository.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/services/impl/alocacao_service.dart';
import 'package:alloc/app/shared/services/impl/ativo_service.dart';
import 'package:alloc/app/shared/services/impl/carteira_service.dart';

import 'app_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:alloc/app/app_widget.dart';
import 'package:alloc/app/modules/home/home_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        $AppController,
        Bind<ICarteiraRepository>((i) => CarteiraRepository()),
        Bind<IAtivoRepository>((i) => AtivoRepository()),
        Bind<IAlocacaoRepository>((i) => AlocacaoRepository()),
        Bind<ICarteiraService>(
            (i) => CarteiraService(carteiraRepository: i.get())),
        Bind<IAtivoService>((i) => AtivoService(ativoRepository: i.get())),
        Bind<IAlocacaoService>(
            (i) => AlocacaoService(alocacaoRepository: i.get())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', module: HomeModule()),
        ModularRouter('/carteira', module: CarteiraModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
