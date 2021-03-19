import 'dart:async';

import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  ICarteiraService _carteiraService = Modular.get<CarteiraService>();
  ReactionDisposer _carteirasReactDispose;
  String descricao;
  Timer _schedule;
  @observable
  String error;

  @observable
  String lastUpdate = "";

  @observable
  List<CarteiraDTO> carteiras = [];

  @observable
  List<AtivoDTO> acoes = [];

  @observable
  List<AtivoDTO> fiis = [];

  @action
  Future<void> init() async {
    try {
      carteiras = AppCore.carteiras;
      loadAcoes();
      loadFiis();
      _startCarteirasReaction();
      _runSchedule();
    } catch (e) {
      LoggerUtil.error(e);
    }
  }

  @computed
  double get patrimonio {
    double total = 0.0;
    carteiras.forEach((e) => total += e.totalAtualizado);
    return total;
  }

  void loadAcoes() {
    List<AtivoDTO> list = AppCore.allAtivos.where((e) => e.isAcao).toList();
    list.sort((e1, e2) =>
        e2.cotacaoModel.variacaoHoje.compareTo(e1.cotacaoModel.variacaoHoje));
    if (list.length > 5) {
      list = list.sublist(0, 5);
    }
    acoes = list;
  }

  void loadFiis() {
    List<AtivoDTO> list = AppCore.allAtivos.where((e) => e.isFII).toList();
    list.sort((e1, e2) =>
        e2.cotacaoModel.variacaoHoje.compareTo(e1.cotacaoModel.variacaoHoje));
    if (list.length > 5) {
      list = list.sublist(0, 5);
    }

    fiis = list;
  }

  @computed
  int get maiorQuantItemsExistenteListas {
    if (acoes.length > fiis.length)
      return acoes.length;
    else
      return fiis.length;
  }

  CotacaoModel getCotacaoIndiceByTipo(TipoAtivo tipo) {
    if (tipo.equals(TipoAtivo.ACAO)) return AppCore.getCotacao("IBOV");
    if (tipo.equals(TipoAtivo.FIIS)) return AppCore.getCotacao("IFIX");
    return CotacaoModel(
      "--",
      0.0,
      0.0,
    );
  }

  double getVariacaoTotalAcoes() {
    return getVariacaoTotal(AppCore.allAtivos.where((e) => e.isAcao).toList(),
        onlyHoje: true)[1];
  }

  double getVariacaoTotalFiis() {
    return getVariacaoTotal(AppCore.allAtivos.where((e) => e.isFII).toList(),
        onlyHoje: true)[1];
  }

  double getVariacaoCarteira(String idCarteira) {
    return getVariacaoTotal(
        AppCore.allAtivos
            .where((e) =>
                e.idCarteira == idCarteira && e.cotacaoModel.variacao != null)
            .toList(),
        onlyHoje: true)[1];
  }

  List getVariacaoPatrimonio() {
    return getVariacaoTotal(
        AppCore.allAtivos
            .where((e) => e.cotacaoModel.variacao != null)
            .toList(),
        onlyHoje: true);
  }

  List getVariacaoTotal(List<AtivoDTO> ativos, {bool onlyHoje = false}) {
    double totalAbertura = 0.0;
    double totalAtual = 0.0;
    ativos.forEach((e) {
      double precoAbertura = onlyHoje
          ? e.cotacaoModel.precoAberturaHoje
          : e.cotacaoModel.precoAbertura;
      totalAbertura += precoAbertura * e.qtd;
      totalAtual += e.cotacaoModel.ultimo * e.qtd;
    });

    double percentual =
        GeralUtil.variacaoPercentualDeXparaY(totalAbertura, totalAtual);

    return [
      GeralUtil.limitaCasasDecimais(totalAtual - totalAbertura),
      GeralUtil.limitaCasasDecimais(percentual)
    ];
  }

  @action
  Future<bool> salvarNovaCarteira() async {
    try {
      if (descricao.length <= 1) {
        //o icone da carteira por exemplo usa as 2 primeiras letras
        error = "A descrição deve ter pelo menos 2 letras!";
        return false;
      }

      await _carteiraService.create(descricao);
      await AppCore.notifyAddDelCarteira();
      return true;
    } on ApplicationException catch (e) {
      error = e.toString();
    } on Exception catch (e) {
      LoggerUtil.error(e);
      error = "Falha ao salvar nova carteira.";
    }
    return false;
  }

  void _runSchedule() {
    if (_schedule != null) _schedule.cancel();

    _schedule = Timer.periodic(new Duration(minutes: 1), (timer) {
      refreshLastUpdate();
    });
  }

  void _startCarteirasReaction() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }

    _carteirasReactDispose = AppCore.createCarteirasReact((e) {
      this.carteiras = AppCore.carteiras;
      loadAcoes();
      loadFiis();
      refreshLastUpdate();
    });
  }

  void refreshLastUpdate() {
    lastUpdate = getLastUpdateCotacoes();
  }

  String getLastUpdateCotacoes() {
    List<AtivoDTO> list =
        AppCore.allAtivos.where((e) => e.cotacaoModel.date != null).toList();
    list.sort((a1, a2) => a2.cotacaoModel.date.compareTo(a1.cotacaoModel.date));

    if (list.isEmpty) return "";

    AtivoDTO ativo = list.first;
    if (ativo.cotacaoModel.date == null ||
        !DateUtil.equals(ativo.cotacaoModel.date, DateTime.now())) return "";

    Duration duration =
        DateUtil.diferenca(ativo.cotacaoModel.date, DateTime.now()).abs();
    if (duration.inDays > 0)
      return "(há ${duration.inDays} ${duration.inDays > 1 ? 'dias' : 'dia'})";
    if (duration.inHours > 0)
      return "(há ${duration.inHours} ${duration.inHours > 1 ? 'horas' : 'hora'})";
    if (duration.inMinutes > 0)
      return "(há ${duration.inMinutes} ${duration.inMinutes > 1 ? 'minutos' : 'minuto'})";

    return "(agora)";
  }

  @action
  Future refresh() async {
    // await SharedMain.refreshCarteiras();
  }
}
