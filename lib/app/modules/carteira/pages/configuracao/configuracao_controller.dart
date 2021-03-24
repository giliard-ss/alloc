import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/services/alocacao_service.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_core.dart';

part 'configuracao_controller.g.dart';

@Injectable()
class ConfiguracaoController = _ConfiguracaoControllerBase with _$ConfiguracaoController;

abstract class _ConfiguracaoControllerBase with Store {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  ICarteiraService _carteiraService = Modular.get<CarteiraService>();
  IAlocacaoService _alocacaoService = Modular.get<AlocacaoService>();
  CarteiraController _carteiraController = Modular.get();
  String superiorId;

  @observable
  List<AlocacaoDTO> alocacoes = [];
  @observable
  double percentualRestante = 0;
  @observable
  bool autoAlocacao;
  bool iniciou = false;

  Future<void> init() async {
    if (!iniciou) {
      _loadAlocacoes();
      checkAlocacoesValues();
      _loadConfigAutoAlocacao();
      iniciou = true;
    }
  }

  void _loadConfigAutoAlocacao() {
    if (StringUtil.isEmpty(superiorId)) {
      autoAlocacao = _carteiraController.carteira.autoAlocacao;
    } else {
      autoAlocacao = AppCore.getAlocacaoById(superiorId).autoAlocacao;
    }
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
    List<AlocacaoDTO> list = List.from(alocacoes);
    list.forEach((e) => e.alocacao = 0);
    alocacoes = list;
  }

  _defineMedia() {
    double media = GeralUtil.limitaCasasDecimais((100 / alocacoes.length) / 100, casasDecimais: 3);

    List<AlocacaoDTO> list = List.from(alocacoes);
    list.forEach((e) => e.alocacao = media);
    alocacoes = list;
  }

  @action
  void checkAlocacoesValues() {
    double percentualTotal = 0;
    alocacoes.forEach((e) {
      percentualTotal += e.alocacaoPercent.toDouble();
    });
    percentualRestante = double.parse(((100 - percentualTotal)).toStringAsFixed(2));
    //percentualRestante = percentualTotal > 100 ? 0 : (100 - percentualTotal);
  }

  Future<String> salvar() async {
    try {
      bool notificarUpdateCarteira = false;
      bool notificarUpdateAlocacao = false;
      await _db.runTransaction((tr) async {
        notificarUpdateCarteira = await _atualizaCarteiraOuAlocacao(tr);
        //se nao atualizar a carteira, entao atualiza a alocacao
        notificarUpdateAlocacao = !notificarUpdateCarteira;

        if (alocacoes.isNotEmpty) {
          await _alocacaoService.saveTransaction(tr, alocacoes, autoAlocacao);
          //await AppCore.notifyUpdateAlocacao();
          notificarUpdateAlocacao = true;
        }
      });

      if (notificarUpdateAlocacao) await AppCore.notifyUpdateAlocacao();
      if (notificarUpdateCarteira) await AppCore.notifyUpdateCarteira();

      return null;
    } on ApplicationException catch (e) {
      return e.toString();
    } catch (e) {
      LoggerUtil.error(e);
      return "Falha ao salvar!";
    }
  }

  Future<bool> _atualizaCarteiraOuAlocacao(Transaction tr) async {
    if (!StringUtil.isEmpty(superiorId)) {
      AlocacaoDTO aloc = AppCore.getAlocacaoById(superiorId);
      aloc.autoAlocacao = autoAlocacao;
      await _alocacaoService.updateTransaction(tr, aloc);
      return false;
    } else {
      CarteiraModel carteira = CarteiraModel.fromMap(_carteiraController.carteira.toMap());
      carteira.autoAlocacao = autoAlocacao;
      await _carteiraService.updateTransaction(tr, carteira);
      return true;
    }
  }

  void _loadAlocacoes() {
    alocacoes = AppCore.getAlocacoesByCarteiraId(_carteiraController.carteira.id, superiorId);
  }
}
