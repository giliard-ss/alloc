import 'dart:async';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/cotacao_model.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

class SharedMain {
  static String _tableCotacoes = "cotacao";
  static StreamSubscription<QuerySnapshot> _listenerCotacoes;
  // static Observable<List<CotacaoModel>> cotacoes =
  //     Observable<List<CotacaoModel>>([]);

  static var cotacoes = Observable<List<CotacaoModel>>([]);

  static void startListenerCotacoes() {
    try {
      if (_listenerCotacoes != null) {
        _listenerCotacoes.cancel();
      }

      CollectionReference reference =
          FirebaseFirestore.instance.collection(_tableCotacoes);
      _listenerCotacoes = reference
          .where("id", whereIn: ['IRBR3', 'OIBR3'])
          .snapshots()
          .listen((snapshot) {
            List<CotacaoModel> result =
                List.generate(snapshot.docs.length, (i) {
              return CotacaoModel.fromMap(snapshot.docs[i].data());
            });
            cotacoes.value = result;
          });
      LoggerUtil.info("Listener de cotações iniciado.");
    } catch (ex) {
      throw new ApplicationException(
          'Falha ao iniciar Listener de cotações!', ex);
    }
  }

  static void stopListenerCotacoes() {
    try {
      _listenerCotacoes.cancel();
      _listenerCotacoes = null;
      LoggerUtil.info("Listener de cotações interrompido.");
    } on Exception catch (ex) {
      throw new ApplicationException(
          'Falha ao interromper Listener de cotações!', ex);
    }
  }
}
