import 'package:alloc/app/shared/config/cf_settings.dart';
import 'package:alloc/app/shared/models/provento_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IProventoRepository {
  Future<List<ProventoModel>> findProventos(DateTime inicio, {onlyCache});
  Future<ProventoModel> findUltimoProventoOrNullAposData(DateTime data, {onlyCache});
}

class ProventoRepository implements IProventoRepository {
  static final _table = "proventos";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<ProventoModel>> findProventos(DateTime inicio, {onlyCache = true}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("data", isGreaterThanOrEqualTo: inicio.millisecondsSinceEpoch)
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));
    return List.generate(snapshot.docs.length, (i) {
      return new ProventoModel.fromMap(snapshot.docs[i].data());
    });
  }

  @override
  Future<ProventoModel> findUltimoProventoOrNullAposData(DateTime data, {onlyCache = true}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("data", isGreaterThanOrEqualTo: data.millisecondsSinceEpoch)
        .orderBy("data", descending: true)
        .limit(1)
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));

    if (snapshot.docs.isEmpty) return null;

    return new ProventoModel.fromMap(snapshot.docs[0].data());
  }
}
