import 'dart:async';

import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

class CotacaoCore {
  String _tableCotacoes = "cotacao";
  StreamSubscription<DocumentSnapshot> _listenerCotacoes;
  var _cotacoes = Observable<List<CotacaoModel>>([]);
  ReactionDisposer _reactionCotacoesDispose;

  CotacaoCore._();

  static Future<CotacaoCore> initInstance() async {
    CotacaoCore cotacaoCore = new CotacaoCore._();
    await cotacaoCore._startListenerCotacoes();
    return cotacaoCore;
  }

  Future<void> _startListenerCotacoes() async {
    try {
      if (_listenerCotacoes != null) {
        await _stopListenerCotacoes();
      }

      DocumentReference reference =
          FirebaseFirestore.instance.collection(_tableCotacoes).doc("ULTIMO");

      _listenerCotacoes = reference.snapshots().listen((snapshot) async {
        List<CotacaoModel> cotacoes = _snapshotToCotacoes(snapshot);
        runInAction(() {
          _cotacoes.value = cotacoes;
        });
      });
      LoggerUtil.info("Listener de cotações iniciado.");
    } catch (ex) {
      throw new ApplicationException('Falha ao iniciar Listener de cotações!', ex);
    }
  }

  List<CotacaoModel> _snapshotToCotacoes(DocumentSnapshot snapshot) {
    List<CotacaoModel> cotacoes = List.generate(snapshot.data()['values'].length, (i) {
      Map mapCotacao = snapshot.data()['values'][i];
      mapCotacao["date"] = snapshot.data()['date'];
      return CotacaoModel.fromMap(mapCotacao);
    });
    return cotacoes;
  }

  Future<void> _stopListenerCotacoes() async {
    try {
      await _listenerCotacoes.cancel();
      _listenerCotacoes = null;
      LoggerUtil.info("Listener de cotações interrompido.");
    } on Exception catch (ex) {
      throw new ApplicationException('Falha ao interromper Listener de cotações!', ex);
    }
  }

  CotacaoModel getCotacao(String id) {
    for (CotacaoModel cm in _cotacoes.value) {
      if (cm.id == id) {
        cm.variacao = cm.variacao == null ? 0.0 : cm.variacao;
        return cm;
      }
    }

    return CotacaoModel(id, 0, 0);
  }

  startReactionCotacoes(Function(List<CotacaoModel> cotacoes) fnc) {
    if (_reactionCotacoesDispose != null) {
      _reactionCotacoesDispose();
    }
    _reactionCotacoesDispose = _createCotacoesReact(fnc);
  }

  ///crie a reacao vinculada a um variavel para que seja possivel chamar o dispose() pra encerrar
  ReactionDisposer _createCotacoesReact(Function(List<CotacaoModel> cotacoes) fnc) {
    return reaction((_) => _cotacoes.value, fnc);
  }

  List<String> get allPapeis {
    List<String> result = [];
    _cotacoes.value.forEach((e) => result.add(e.id));
    return result;
  }
}
