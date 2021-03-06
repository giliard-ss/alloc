import 'package:cloud_firestore/cloud_firestore.dart';

class IParametroRepository {}

class ParametroRepository implements IParametroRepository {
  static final _table = "parametros";
  FirebaseFirestore _db = FirebaseFirestore.instance;
}
