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
      await ref.set(carteira.toMap());
      return carteira;
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao criar nova carteira do usuário $idUsuario! ' +
              e.toString());
    }
  }

  @override
  Future<void> update(CarteiraModel carteira) async {
    try {
      return _db.collection(_table).doc(carteira.id).set(carteira.toMap());
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao atualizar a carteira ${carteira.id}! ' + e.toString());
    }
  }

  @override
  void deleteBatch(WriteBatch batch, String idCarteira) {
    try {
      DocumentReference ref = _db.collection(_table).doc(idCarteira);
      batch.delete(ref);
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao deletar carteira $idCarteira! ' + e.toString());
    }
  }

  @override
  void updateBatch(WriteBatch batch, CarteiraModel carteira) {
    try {
      DocumentReference ref = _db.collection(_table).doc(carteira.id);
      batch.set(ref, carteira.toMap());
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao atualizar a carteira ${carteira.id}! ' + e.toString());
    }
  }
}
