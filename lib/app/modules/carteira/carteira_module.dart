import 'package:alloc/app/modules/carteira/pages/provento/provento_controller.dart';
import 'package:alloc/app/modules/carteira/pages/provento/provento_crud_controller.dart';
import 'package:alloc/app/modules/carteira/pages/provento/provento_crud_page.dart';
import 'package:alloc/app/modules/carteira/pages/saque/saque_page.dart';
import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
import 'pages/saque/saque_controller.dart';
import 'package:alloc/app/modules/carteira/pages/deposito/deposito_page.dart';
import 'pages/deposito/deposito_controller.dart';
import 'package:alloc/app/modules/carteira/pages/configuracao/configuracao_page.dart';
import 'package:alloc/app/modules/carteira/pages/provento/provento_page.dart';
import 'package:alloc/app/modules/extrato/extrato_controller.dart';
import 'package:alloc/app/modules/extrato/extrato_page.dart';
import 'pages/configuracao/configuracao_controller.dart';
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
        $SaqueController,
        $DepositoController,
        $ProventoCrudController,
        $ProventoController,
        $ConfiguracaoController,
        $AtivoController,
        $SubAlocacaoController,
        $CarteiraController,
        $ExtratoController
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter("/:id", child: (_, args) => CarteiraPage(args.params['id'])),
        ModularRouter("/sub-alocacao/:id", child: (_, args) => SubAlocacaoPage(args.params['id'])),
        ModularRouter("/ativo/:id",
            child: (_, args) => AtivoPage(
                  id: args.params['id'],
                )),
        ModularRouter("/ativo/comprar",
            child: (_, args) => AtivoPage(
                  tipoEvento: TipoEvento.APLICACAO.code,
                )),
        ModularRouter("/ativo/comprar/papel/:papel",
            child: (_, args) => AtivoPage(
                  tipoEvento: TipoEvento.APLICACAO.code,
                  papel: args.params['papel'],
                )),
        ModularRouter("/ativo/comprar/alocacao/:idAlocacao",
            child: (_, args) => AtivoPage(
                  idAlocacao: args.params['idAlocacao'],
                  tipoEvento: TipoEvento.APLICACAO.code,
                )),
        ModularRouter("/ativo/comprar/alocacao/:idAlocacao/papel/:papel",
            child: (_, args) => AtivoPage(
                  idAlocacao: args.params['idAlocacao'],
                  papel: args.params['papel'],
                  tipoEvento: TipoEvento.APLICACAO.code,
                )),
        ModularRouter("/ativo/vender/alocacao/:idAlocacao/papel/:papel",
            child: (_, args) => AtivoPage(
                  idAlocacao: args.params['idAlocacao'],
                  papel: args.params['papel'],
                  tipoEvento: TipoEvento.VENDA.code,
                )),
        ModularRouter("/ativo/vender/papel/:papel",
            child: (_, args) => AtivoPage(
                  tipoEvento: TipoEvento.VENDA.code,
                  papel: args.params['papel'],
                )),
        ModularRouter("/config", child: (_, args) => ConfiguracaoPage(null)),
        ModularRouter("/config/:idAlocacao",
            child: (_, args) => ConfiguracaoPage(args.params['idAlocacao'])),
        ModularRouter("/extrato",
            transition: TransitionType.downToUp,
            duration: Duration(milliseconds: 500),
            child: (_, args) => ExtratoPage()),
        ModularRouter("/provento",
            transition: TransitionType.downToUp,
            duration: Duration(milliseconds: 500),
            child: (_, args) => ProventoPage()),
        ModularRouter("/provento/crud", child: (_, args) => ProventoCrudPage()),
        ModularRouter("/provento/crud/:id",
            child: (_, args) => ProventoCrudPage(
                  id: args.params['id'],
                )),
        ModularRouter("/deposito",
            transition: TransitionType.downToUp,
            duration: Duration(milliseconds: 500),
            child: (_, args) => DepositoPage()),
        ModularRouter("/deposito/:id",
            child: (_, args) => DepositoPage(
                  id: args.params['id'],
                )),
        ModularRouter("/saque",
            transition: TransitionType.downToUp,
            duration: Duration(milliseconds: 500),
            child: (_, args) => SaquePage()),
        ModularRouter("/saque/:id",
            child: (_, args) => SaquePage(
                  id: args.params['id'],
                )),
      ];

  static Inject get to => Inject<CarteiraModule>.of();
}
