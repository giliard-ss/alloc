import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/utils/ativo_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_core.dart';

part 'cotacao_controller.g.dart';

@Injectable()
class CotacaoController = _CotacaoControllerBase with _$CotacaoController;

abstract class _CotacaoControllerBase with Store {
  String _tipo;
  bool _isB3;

  @observable
  List<CotacaoModel> cotacoes = [];

  Future<void> init() async {
    try {
      if (_tipo == TipoAtivo.ACAO.code || _tipo == TipoAtivo.ETF.code) loadCotacoesAcoesAndETFs();
      if (_tipo == TipoAtivo.FIIS.code) loadCotacoesFIIs();
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  void loadCotacoesAcoesAndETFs() {
    cotacoes = [];
    if (_isB3)
      AppCore.allCotacoes.where((e) => e.isAcao() || e.isETF()).forEach((e) => cotacoes.add(e));
    else
      AtivoUtil.agruparAtivosPorPapel(AppCore.allAtivos.where((e) => e.isAcao || e.isETF).toList())
          .forEach((e) => cotacoes.add(e.cotacaoModel));
    cotacoes.sort((e1, e2) => e2.variacaoHoje.compareTo(e1.variacaoHoje));
  }

  void loadCotacoesFIIs() {
    cotacoes = [];
    if (_isB3)
      AppCore.allCotacoes.where((e) => e.isFIIS()).forEach((e) => cotacoes.add(e));
    else
      AtivoUtil.agruparAtivosPorPapel(AppCore.allAtivos.where((e) => e.isFII).toList())
          .forEach((e) => cotacoes.add(e.cotacaoModel));
    cotacoes.sort((e1, e2) => e2.variacaoHoje.compareTo(e1.variacaoHoje));
  }

  set tipo(String value) => this._tipo = value;
  set isB3(value) => this._isB3 = value;
}
