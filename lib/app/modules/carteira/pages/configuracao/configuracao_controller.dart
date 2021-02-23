import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/services/impl/alocacao_service.dart';
import 'package:alloc/app/shared/services/impl/ativo_service.dart';
import 'package:alloc/app/shared/services/impl/carteira_service.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_core.dart';

part 'configuracao_controller.g.dart';

@Injectable()
class ConfiguracaoController = _ConfiguracaoControllerBase
    with _$ConfiguracaoController;

abstract class _ConfiguracaoControllerBase with Store {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  ICarteiraService _carteiraService = Modular.get<CarteiraService>();
  IAlocacaoService _alocacaoService = Modular.get<AlocacaoService>();
  IAtivoService _ativoService = Modular.get<AtivoService>();
  CarteiraController _carteiraController = Modular.get();
  String superiorId;

  @observable
  List<AlocacaoDTO> alocacoes = [];
  @observable
  List<AtivoDTO> ativos = [];
  @observable
  double percentualRestante = 0;
  @observable
  bool autoAlocacao;
  bool iniciou = false;

  Future<void> init() async {
    if (!iniciou) {
      _loadAlocacoesOuAtivos();
      checkAlocacoesValues();
      _loadConfigAutoAlocacao();
      iniciou = true;
    }
  }

  void _loadAlocacoesOuAtivos() {
    _loadAlocacoes();
    if (alocacoes.isEmpty) {
      _loadAtivos();
    }
  }

  void _loadConfigAutoAlocacao() {
    if (StringUtil.isEmpty(superiorId)) {
      autoAlocacao = _carteiraController.carteira.autoAlocacao;
    } else {
      autoAlocacao = AppCore.getAlocacaoById(superiorId).autoAlocacao;
    }
  }

  void _loadAtivos() {
    runInAction(() {
      ativos = AppCore.getAtivosByIdSuperior(superiorId);
    });
  }

  @action
  void changeAutoAlocacao(bool value) {
    autoAlocacao = value;
    if (value)
      _defineMedia();
    else
      _zeraValores();
  }

  _zeraValores() {
    if (alocacoes.isNotEmpty) {
      List<AlocacaoDTO> list = List.from(alocacoes);
      list.forEach((e) => e.alocacao = 0);
      alocacoes = list;
    } else {
      List<AtivoDTO> list = List.from(ativos);
      list.forEach((e) => e.alocacao = 0);
      ativos = list;
    }
  }

  _defineMedia() {
    if (alocacoes.isNotEmpty) {
      double media = GeralUtil.limitaCasasDecimais(
          (100 / alocacoes.length) / 100,
          casasDecimais: 3);

      List<AlocacaoDTO> list = List.from(alocacoes);
      list.forEach((e) => e.alocacao = media);
      alocacoes = list;
    } else {
      double media = GeralUtil.limitaCasasDecimais((100 / ativos.length) / 100,
          casasDecimais: 3);

      List<AtivoDTO> list = List.from(ativos);
      list.forEach((e) => e.alocacao = media);
      ativos = list;
    }
  }

  @action
  void checkAlocacoesValues() {
    double percentualTotal = 0;
    alocacoes.forEach((e) {
      percentualTotal += e.alocacaoPercent.toDouble();
    });
    percentualRestante =
        double.parse(((100 - percentualTotal)).toStringAsFixed(2));
    //percentualRestante = percentualTotal > 100 ? 0 : (100 - percentualTotal);
  }

  @action
  void checkAtivosValues() {
    double percentualTotal = 0;
    ativos.forEach((e) {
      percentualTotal += e.alocacaoPercent.toDouble();
    });
    percentualRestante =
        double.parse(((100 - percentualTotal)).toStringAsFixed(2));
    //percentualRestante = percentualTotal > 100 ? 0 : (100 - percentualTotal);
  }

  Future<String> salvar() async {
    try {
      bool notificarUpdateCarteira = false;
      bool notificarUpdateAlocacao = false;
      bool notificarUpdateAtivos = false;
      WriteBatch batch = _db.batch();
      notificarUpdateCarteira = _atualizaCarteiraOuAlocacao(batch);
      //se nao atualizar a carteira, entao atualiza a alocacao
      notificarUpdateAlocacao = !notificarUpdateCarteira;

      if (alocacoes.isNotEmpty) {
        _alocacaoService.saveBatch(batch, alocacoes, autoAlocacao);
        await AppCore.notifyUpdateAlocacao();
        notificarUpdateAlocacao = true;
      } else if (ativos.isNotEmpty) {
        _ativoService.saveBatch(batch, ativos, autoAlocacao);
        notificarUpdateAtivos = true;
      }

      batch.commit();

      if (notificarUpdateAtivos) await AppCore.notifyUpdateAtivo();
      if (notificarUpdateAlocacao) await AppCore.notifyUpdateAlocacao();
      if (notificarUpdateCarteira) await AppCore.notifyUpdateCarteira();

      return null;
    } catch (e) {
      LoggerUtil.error(e);
      return "Falha ao salvar!";
    }
  }

  bool _atualizaCarteiraOuAlocacao(WriteBatch batch) {
    if (!StringUtil.isEmpty(superiorId)) {
      AlocacaoDTO aloc = AppCore.getAlocacaoById(superiorId);
      aloc.autoAlocacao = autoAlocacao;
      _alocacaoService.updateBatch(batch, aloc);
      return false;
    } else {
      CarteiraModel carteira =
          CarteiraModel.fromMap(_carteiraController.carteira.toMap());
      carteira.autoAlocacao = autoAlocacao;
      _carteiraService.updateBatch(batch, carteira);
      return true;
    }
  }

  void _loadAlocacoes() {
    alocacoes = AppCore.getAlocacoesByCarteiraId(
        _carteiraController.carteira.id, superiorId);
  }
}
