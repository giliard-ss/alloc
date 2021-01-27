import 'package:alloc/app/shared/exceptions/application_exception.dart';
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
      throw ApplicationException(
          'Falha ao consultar os ativos do usuário $idUsuario! ' +
              e.toString());
    }
  }

  @override
  Future<CarteiraModel> create(String idUsuario, String descricao) async {
    try {
      DocumentReference ref = _db.collection(_table).doc();
      CarteiraModel carteira = CarteiraModel(ref.id, idUsuario, descricao, 0);
      await _db.runTransaction((transaction) async {
        transaction.set(ref, carteira.toMap());
      });
      return carteira;
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao criar nova carteira! ' + e.toString());
    }
  }
}
