import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/repositories/iativo_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtivoRepository implements IAtivoRepository {
  static final _table = "ativos";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<AtivoModel>> findAtivos(String idUsuario) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idUsuario", isEqualTo: idUsuario)
          .get();
      return List.generate(snapshot.docs.length, (i) {
        return AtivoModel.fromMap(snapshot.docs[i].data());
      });
    } catch (e) {
      throw ApplicationException(
          'Falha ao consultar os ativos do usuário $idUsuario! ' +
              e.toString());
    }
  }

  @override
  AtivoModel saveBatch(WriteBatch batch, AtivoModel ativoModel) {
    try {
      DocumentReference ref;
      if (ativoModel.id == null) {
        ref = _db.collection(_table).doc();
        ativoModel.id = ref.id;
      } else {
        ref = _db.collection(_table).doc(ativoModel.id);
      }

      batch.set(ref, ativoModel.toMap());
      return ativoModel;
    } catch (e) {
      throw ApplicationException(
          'Falha ao cadastrar ativos do usuario ${ativoModel.idUsuario} ' +
              e.toString());
    }
  }

  @override
  void deleteBatch(WriteBatch batch, AtivoModel ativoModel) {
    try {
      DocumentReference ref = _db.collection(_table).doc(ativoModel.id);
      batch.delete(ref);
    } catch (e) {
      throw ApplicationException(
          'Falha ao deletar ativos do usuario ${ativoModel.idUsuario} ' +
              e.toString());
    }
  }

  @override
  Future<void> deleteByCarteiraBatch(
      WriteBatch batch, String carteiraId) async {
    try {
      QuerySnapshot query = await _db
          .collection(_table)
          .where("idCarteira", isEqualTo: carteiraId)
          .get();
      query.docs.forEach((QueryDocumentSnapshot doc) {
        batch.delete(doc.reference);
      });
    } catch (e) {
      throw ApplicationException(
          'Falha ao deletar ativos da carteira $carteiraId ' + e.toString());
    }
  }
}
