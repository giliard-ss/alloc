import 'package:alloc/app/shared/utils/connection_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IFirebaseAdapter {
  Future<T> runTransaction<T>(Future<T> Function(Transaction) fnc);
}

class FirebaseAdapter implements IFirebaseAdapter {
  FirebaseFirestore _instance = FirebaseFirestore.instance;

  @override
  Future<T> runTransaction<T>(Future<T> Function(Transaction) fnc) async {
    await ConnectionUtil.checkConnection();
    return _instance.runTransaction(fnc);
  }
}
