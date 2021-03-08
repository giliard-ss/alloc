import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseUtil {
  static Future runTransaction(Function(Transaction tr) fnc) async {
    return FirebaseFirestore.instance.runTransaction((tr) async {
      fnc(tr);
    }, timeout: Duration(seconds: 10)).catchError((e) {
      print("ERRORRRRRRRRRRR " + e.toString());
    });
  }
}
