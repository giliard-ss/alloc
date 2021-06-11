import 'dart:async';

import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/utils/ativo_util.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  static const int QUANT_ATIVOS_EM_ALTA_OU_BAIXA = 3;
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
  List<CotacaoModel> acoesEmAlta = [];

  @observable
  List<CotacaoModel> acoesEmBaixa = [];

  @observable
  List<CotacaoModel> acoesEmAltaB3 = [];

  @observable
  List<CotacaoModel> acoesEmBaixaB3 = [];

  @observable
  List<CotacaoModel> fiisEmAlta = [];

  @observable
  List<CotacaoModel> fiisEmBaixa = [];

  @observable
  List<CotacaoModel> fiisEmAltaB3 = [];

  @observable
  List<CotacaoModel> fiisEmBaixaB3 = [];

  @action
  Future<void> init() async {
    try {
      carteiras = AppCore.carteiras;
      loadAcoes();
      loadFiis();
      _loadAcoesB3();
      _loadFiisB3();
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
    List<CotacaoModel> list = [];
    AtivoUtil.agruparAtivosPorPapel(AppCore.allAtivos.where((e) => e.isAcao || e.isETF).toList())
        .forEach((e) => list.add(e.cotacaoModel));
    list.sort((e1, e2) => e2.variacaoHoje.compareTo(e1.variacaoHoje));

    acoesEmAlta = _extrairCotacoesEmAlta(list);
    acoesEmBaixa = _extrairCotacoesEmBaixa(list);
  }

  void _loadAcoesB3() {
    List<CotacaoModel> list = AppCore.allCotacoes.where((e) => e.isAcao() || e.isETF()).toList();
    list.sort((e1, e2) => e2.variacaoHoje.compareTo(e1.variacaoHoje));

    acoesEmAltaB3 = _extrairCotacoesEmAlta(list);
    acoesEmBaixaB3 = _extrairCotacoesEmBaixa(list);
  }

  List<CotacaoModel> _extrairCotacoesEmAlta(List<CotacaoModel> cotacoes) {
    List<CotacaoModel> result = [];
    bool cotacoesAtualizadasHoje = cotacoes.isNotEmpty &&
        DateUtil.equals(
          cotacoes[0].date,
          DateTime.now(),
        );
    for (int i = 0; i < cotacoes.length; i++) {
      if (i >= QUANT_ATIVOS_EM_ALTA_OU_BAIXA) break;
      if (cotacoesAtualizadasHoje && cotacoes[i].variacaoHoje <= 0) break;
      result.add(cotacoes[i]);
    }
    return result;
  }

  List<CotacaoModel> _extrairCotacoesEmBaixa(List<CotacaoModel> cotacoes) {
    List<CotacaoModel> result = [];
    bool cotacoesAtualizadasHoje = cotacoes.isNotEmpty &&
        DateUtil.equals(
          cotacoes[0].date,
          DateTime.now(),
        );

    for (int i = cotacoes.length - 1; i >= 0; i--) {
      if (i < cotacoes.length - QUANT_ATIVOS_EM_ALTA_OU_BAIXA) break;
      if (cotacoesAtualizadasHoje && cotacoes[i].variacaoHoje >= 0) break;
      result.add(cotacoes[i]);
    }
    return result;
  }

  void loadFiis() {
    List<CotacaoModel> list = [];
    AppCore.allAtivos.where((e) => e.isFII).forEach((e) => list.add(e.cotacaoModel));
    list.sort((e1, e2) => e2.variacaoHoje.compareTo(e1.variacaoHoje));

    fiisEmAlta = _extrairCotacoesEmAlta(list);
    fiisEmBaixa = _extrairCotacoesEmBaixa(list);
  }

  void _loadFiisB3() {
    List<CotacaoModel> list = [];
    AppCore.allCotacoes.where((e) => e.isFIIS()).forEach((e) => list.add(e));
    list.sort((e1, e2) => e2.variacaoHoje.compareTo(e1.variacaoHoje));

    fiisEmAltaB3 = _extrairCotacoesEmAlta(list);
    fiisEmBaixaB3 = _extrairCotacoesEmBaixa(list);
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
    return getVariacaoTotal(AppCore.allAtivos.where((e) => e.isAcao || e.isETF).toList(),
        onlyHoje: true)[1];
  }

  double getVariacaoTotalFiis() {
    return getVariacaoTotal(AppCore.allAtivos.where((e) => e.isFII).toList(), onlyHoje: true)[1];
  }

  double getVariacaoCarteira(String idCarteira) {
    return getVariacaoTotal(
        AppCore.allAtivos
            .where((e) => e.idCarteira == idCarteira && e.cotacaoModel.variacao != null)
            .toList(),
        onlyHoje: true)[1];
  }

  List getVariacaoPatrimonio() {
    return getVariacaoTotal(
        AppCore.allAtivos.where((e) => e.cotacaoModel.variacao != null).toList(),
        onlyHoje: true);
  }

  List getVariacaoTotal(List<AtivoDTO> ativos, {bool onlyHoje = false}) {
    double totalAbertura = 0.0;
    double totalAtual = 0.0;
    ativos.forEach((e) {
      double precoAbertura =
          onlyHoje ? e.cotacaoModel.precoAberturaHoje : e.cotacaoModel.precoAbertura;
      totalAbertura += precoAbertura * e.qtd;
      totalAtual += e.cotacaoModel.ultimo * e.qtd;
    });

    double percentual = GeralUtil.variacaoPercentualDeXparaY(totalAbertura, totalAtual);

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

    _schedule = Timer.periodic(new Duration(seconds: 60), (timer) {
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
      _loadAcoesB3();
      refreshLastUpdate();
    });
  }

  void refreshLastUpdate() {
    lastUpdate = getLastUpdateCotacoes();
  }

  String getLastUpdateCotacoes() {
    List<AtivoDTO> list = AppCore.allAtivos.where((e) => e.cotacaoModel.date != null).toList();
    list.sort((a1, a2) => a2.cotacaoModel.date.compareTo(a1.cotacaoModel.date));

    if (list.isEmpty) return "";

    AtivoDTO ativo = list.first;
    if (ativo.cotacaoModel.date == null ||
        !DateUtil.equals(ativo.cotacaoModel.date, DateTime.now())) return "";

    Duration duration = DateUtil.diferenca(ativo.cotacaoModel.date, DateTime.now()).abs();
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

  void dispose() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }
  }
}
