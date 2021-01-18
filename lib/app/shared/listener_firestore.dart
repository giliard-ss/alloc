import 'dart:async';

import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/exception_util.dart';
import 'package:alloc/app/shared/utils/logger_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

class ListenerFirestore {
  static StreamSubscription<QuerySnapshot> streamSub;
  static Observable<String> cotacao = Observable("0");
  static final log = getLogger();
  static init() async {
    // CollectionReference reference =
    //     FirebaseFirestore.instance.collection('cotacao');

    // streamSub =
    //     reference.where("id", whereIn: ["IRBR3"]).snapshots().listen((result) {
    //           result.docs.forEach((d) {
    //             ref(d.data()['ultimo'].toString());
    //             print(cotacao);
    //           });
    //         });

    // CollectionReference reference =
    //     FirebaseFirestore.instance.collection('cotacao');
    // streamSub = reference
    //     .where("id", whereIn: ["IRBR3"])
    //     .snapshots()
    //     .listen((querySnapshot) {
    //       querySnapshot.docChanges.forEach((change) {
    //         // print(change.doc.data());
    //         ref(change.doc.data()['ultimo'].toString());
    //       });
    //     });
    var str = Future.delayed(Duration(seconds: 2), () {
      try {
        vv();
      } catch (e) {
        // log.w(e, [e]);
        ExceptionUtil.throwe(e);
      }
    });
    return str;
//somewhere
  }

  static vv() {
    throw ApplicationException("teste 0");
  }

  static stop() {
    // streamSub.cancel();
    //SharedMain.stopListenerCotacoes();
  }

  static ref(String value) {
    cotacao.value = value;
  }
}
