import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/repositories/ialocacao_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlocacaoRepository implements IAlocacaoRepository {
  static final _table = "alocacoes";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<AlocacaoModel>> findAlocacoes(String idUsuario) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idUsuario", isEqualTo: idUsuario)
          .get();
      return List.generate(snapshot.docs.length, (i) {
        return AlocacaoModel.fromMap(snapshot.docs[i].data());
      });
    } catch (e) {
      throw ApplicationException(
          'Falha ao consultar alocacoes do usuario $idUsuario! ' +
              e.toString());
    }
  }

  @override
  AlocacaoModel saveBatch(WriteBatch batch, AlocacaoModel alocacaoModel) {
    try {
      DocumentReference ref;
      if (alocacaoModel.id == null) {
        ref = _db.collection(_table).doc();
        alocacaoModel.id = ref.id;
      } else {
        ref = _db.collection(_table).doc(alocacaoModel.id);
      }

      batch.set(ref, alocacaoModel.toMap());
      return alocacaoModel;
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao salvar nova alocação! ' + e.toString());
    }
  }

  @override
  void deleteBatch(WriteBatch batch, String idAlocacao) {
    try {
      DocumentReference ref = _db.collection(_table).doc(idAlocacao);
      batch.delete(ref);
    } catch (e) {
      throw ApplicationException(
          'Falha ao salvar nova alocação! ' + e.toString());
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

      query.docs.forEach((doc) {
        batch.delete(doc.reference);
      });
    } catch (e) {
      throw ApplicationException(
          'Falha ao deletar alocações da carteira $carteiraId ' + e.toString());
    }
  }

  @override
  Future update(AlocacaoModel alocacaoModel) async {
    try {
      return _db
          .collection(_table)
          .doc(alocacaoModel.id)
          .set(alocacaoModel.toMap());
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao salvar nova alocação! ' + e.toString());
    }
  }

  @override
  void updateBatch(WriteBatch batch, AlocacaoModel alocacaoModel) {
    try {
      DocumentReference ref = _db.collection(_table).doc(alocacaoModel.id);
      batch.set(ref, alocacaoModel.toMap());
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao salvar nova alocação! ' + e.toString());
    }
  }
}
