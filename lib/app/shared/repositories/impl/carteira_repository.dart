import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/repositories/icarteira_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarteiraRepository implements ICarteiraRepository {
  static final _table = "carteiras";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<CarteiraModel>> findCarteiras(String idUsuario) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idUsuario", isEqualTo: idUsuario)
          .get();
      return List.generate(snapshot.docs.length, (i) {
        return CarteiraModel.fromMap(snapshot.docs[i].data());
      });
    } catch (e) {
      print(e);
      return [];
    }
  }
}
