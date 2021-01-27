import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/services/impl/alocacao_service.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'dtos/alocacao_dto.dart';

part 'carteira_controller.g.dart';

@Injectable()
class CarteiraController = _CarteiraControllerBase with _$CarteiraController;

abstract class _CarteiraControllerBase with Store {
  CarteiraDTO _carteira;
  ReactionDisposer _carteirasReactDispose;
  IAlocacaoService _alocacaoService = Modular.get<AlocacaoService>();
  Observable<List<AlocacaoDTO>> allAlocacoes =
      Observable<List<AlocacaoDTO>>([]);

  String novaAlocacaoDesc;

  @observable
  List<AlocacaoDTO> alocacoes = [];

  @observable
  String novaAlocacaoError;

  Future<void> init() async {
    await loadAlocacoes();
    _startCarteirasReaction();
    _refreshAlocacoes();
  }

  Future<bool> salvarNovaAlocacao() async {
    try {
      await _alocacaoService.create(novaAlocacaoDesc, _carteira.id, null);
      await loadAlocacoes();
      return true;
    } on Exception catch (e) {
      LoggerUtil.error(e);
      novaAlocacaoError = "Falha ao salvar nova alocação.";
      return false;
    }
  }

  Future<void> loadAlocacoes() async {
    List<AlocacaoDTO> result = [];
    List<AlocacaoModel> list =
        await _alocacaoService.getAlocacoes(_carteira.id);
    list.forEach((a) => result.add(AlocacaoDTO(a)));
    allAlocacoes.value = result;
    alocacoes = result.where((i) => i.idSuperior == null).toList();
  }

  void _startCarteirasReaction() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }

    _carteirasReactDispose =
        SharedMain.createCarteirasReact((List<CarteiraDTO> carteiras) {
      _refreshCarteira();
    });
  }

  _refreshCarteira() {
    _carteira = SharedMain.getCarteira(_carteira.id);
    _refreshAlocacoes();
  }

  _refreshAlocacoes() async {
    List<AlocacaoDTO> result = [];
    for (AlocacaoDTO aloc in allAlocacoes.value) {
      aloc.totalAportado = SharedMain.getTotalAportadoAtivosByAlocacao(aloc.id);
      aloc.totalAportadoAtual = aloc.totalAportado +
          (SharedMain.getRendimentoAtivosByAlocacao(aloc.id));

      double totalAposAporte =
          _carteira.getTotalAposAporte() * aloc.alocacaoDouble;
      aloc.totalInvestir = totalAposAporte - aloc.totalAportadoAtual;

      result.add(aloc);
    }
    allAlocacoes.value = result;
    alocacoes = result.where((i) => i.idSuperior == null).toList();
  }

  void setCarteira(String carteiraId) {
    _carteira = SharedMain.getCarteira(carteiraId);
  }

  String get title => _carteira.descricao;

  CarteiraDTO get carteira => _carteira;

  void dispose() {
    if (_carteirasReactDispose != null) {
      _carteirasReactDispose();
    }
  }
}
