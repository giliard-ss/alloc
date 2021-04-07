import 'package:alloc/app/modules/carteira/carteira_module.dart';
import 'package:alloc/app/shared/repositories/alocacao_repository.dart';
import 'package:alloc/app/shared/repositories/ativo_repository.dart';
import 'package:alloc/app/shared/repositories/auth_repository.dart';
import 'package:alloc/app/shared/repositories/carteira_repository.dart';
import 'package:alloc/app/shared/repositories/event_repository.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/services/preference_service.dart';
import 'package:alloc/app/splash/splash_page.dart';
import 'splash/splash_controller.dart';
import 'package:alloc/app/modules/login/login_module.dart';
import 'app_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:alloc/app/app_widget.dart';
import 'package:alloc/app/modules/home/home_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        $SplashController,
        $AppController,
        Bind<IAuthRepository>((i) => AuthRepository()),
        Bind<IEventRepository>((i) => EventRepository()),
        Bind<ICarteiraRepository>((i) => CarteiraRepository()),
        Bind<IAtivoRepository>((i) => AtivoRepository()),
        Bind<IAlocacaoRepository>((i) => AlocacaoRepository()),
        Bind<IPreferenceService>((i) => PreferenceService()),
        Bind<ICarteiraService>((i) => CarteiraService(
            carteiraRepository: i.get(),
            ativoRepository: i.get(),
            alocacaoRepository: i.get(),
            eventRepository: i.get())),
        Bind<IAtivoService>((i) => AtivoService(ativoRepository: i.get())),
        Bind<IAlocacaoService>((i) => AlocacaoService(alocacaoRepository: i.get())),
        Bind<IEventService>((i) => EventService(ativoService: i.get(), eventRepository: i.get())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', child: (_, args) => SplashPage()),
        ModularRouter('/login', module: LoginModule()),
        ModularRouter('/home', module: HomeModule()),
        ModularRouter('/carteira', module: CarteiraModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
