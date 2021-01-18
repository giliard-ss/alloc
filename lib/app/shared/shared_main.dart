import 'dart:async';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/services/impl/ativo_service.dart';
import 'package:alloc/app/shared/services/impl/carteira_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'dtos/carteira_dto.dart';

class SharedMain {
  static ICarteiraService _carteiraService;
  static IAtivoService _ativoService;
  static String _tableCotacoes = "cotacao";
  static StreamSubscription<QuerySnapshot> _listenerCotacoes;
  static var _cotacoes = Observable<List<CotacaoModel>>([]);
  static var _ativos = Observable<List<AtivoModel>>([]);
  static var _carteiras = Observable<List<CarteiraModel>>([]);
  static var _carteirasDTO = Observable<List<CarteiraDTO>>([]);
  static UsuarioModel _usuario;
  static ReactionDisposer _reactionCotacoesDispose;

  static Future<void> init(UsuarioModel usuario) async {
    _usuario = usuario;
    _carteiraService = Modular.get<CarteiraService>();
    _ativoService = Modular.get<AtivoService>();
    await _loadCarteiras();
    await _loadAtivos();
    await _startListenerCotacoes();
    _startReactionCotacoes();
  }

  static Future<void> _loadCarteiras() async {
    await runInAction(() async {
      _carteiras.value = await _carteiraService.getCarteiras(_usuario.id);
    });
  }

  static CotacaoModel _getCotacao(String id) {
    for (CotacaoModel cm in _cotacoes.value) {
      if (cm.id == id) {
        return cm;
      }
    }

    throw ApplicationException('Cotação não encontrada para o id: $id');
  }

  static _startReactionCotacoes() {
    if (_reactionCotacoesDispose != null) {
      _reactionCotacoesDispose();
    }
    _reactionCotacoesDispose = _createCotacoesReact((e) {
      ///toda vez que as cotacoes forem atualizadas, os valores da carteiraDTO tambem serao
      _refreshCarteiraDTO();
    });
  }

  static void _refreshCarteiraDTO() {
    List<CarteiraDTO> carteiras = [];
    _carteiras.value.forEach((carteira) {
      double totalAportadoAtivos = _getTotalAportadoAtivos(carteira.id);
      double rendimentoAtivos = _getRendimentoAtivos(carteira.id);
      double totalAportadoComRendimento =
          (totalAportadoAtivos + (rendimentoAtivos));
      carteiras.add(CarteiraDTO(
          carteira, totalAportadoAtivos, totalAportadoComRendimento));
    });
    _carteirasDTO.value = carteiras;
  }

  static double _getRendimentoAtivos(String idCarteira) {
    double totalAgora = 0;
    double totalAportado = 0;
    _ativos.value.forEach((e) {
      if (e.idCarteira == idCarteira) {
        totalAgora += e.qtd * _getCotacao(e.papel).ultimo.toDouble();
        totalAportado += e.totalAportado.toDouble();
      }
    });

    return totalAgora - totalAportado;
  }

  ///crie a reacao vinculada a um variavel para que seja possivel chamar o dispose() pra encerrar
  static ReactionDisposer _createCotacoesReact(
      Function(List<CotacaoModel> cotacoes) fnc) {
    return reaction((_) => _cotacoes.value, fnc);
  }

  ///toda vez que _carteirasDTO sofrer alteracao de valor, executará a função em parametro
  static ReactionDisposer createCarteirasReact(
      Function(List<CarteiraDTO> carteiras) fnc) {
    return reaction((_) => _carteirasDTO.value, fnc);
  }

  static Future<void> _loadAtivos() async {
    await runInAction(() async {
      _ativos.value = await _ativoService.getAtivos(_usuario.id);
    });
  }

  static List<String> _getPapeisAtivos() {
    return List.generate(_ativos.value.length, (i) {
      return _ativos.value[i].papel;
    });
  }

  static double _getTotalAportadoAtivos(String idCarteira) {
    double total = 0;
    _ativos.value.forEach((e) {
      if (e.idCarteira == idCarteira) {
        total += e.totalAportado.toDouble();
      }
    });
    return total;
  }

  static Future<void> _startListenerCotacoes() async {
    try {
      if (_listenerCotacoes != null) {
        await _stopListenerCotacoes();
      }

      List<String> papeis = _getPapeisAtivos();
      if (papeis.isEmpty) {
        return;
      }

      CollectionReference reference =
          FirebaseFirestore.instance.collection(_tableCotacoes);
      _listenerCotacoes =
          reference.where("id", whereIn: papeis).snapshots().listen((snapshot) {
        _cotacoes.value = List.generate(snapshot.docs.length, (i) {
          return CotacaoModel.fromMap(snapshot.docs[i].data());
        });
      });
      LoggerUtil.info("Listener de cotações iniciado.");
    } catch (ex) {
      throw new ApplicationException(
          'Falha ao iniciar Listener de cotações!', ex);
    }
  }

  static Future<void> _stopListenerCotacoes() async {
    try {
      await _listenerCotacoes.cancel();
      _listenerCotacoes = null;
      LoggerUtil.info("Listener de cotações interrompido.");
    } on Exception catch (ex) {
      throw new ApplicationException(
          'Falha ao interromper Listener de cotações!', ex);
    }
  }

  static List<CarteiraDTO> get carteiras => _carteirasDTO.value;
}
