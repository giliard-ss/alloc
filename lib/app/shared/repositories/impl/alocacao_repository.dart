import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/repositories/ialocacao_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlocacaoRepository implements IAlocacaoRepository {
  static final _table = "alocacoes";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<AlocacaoModel>> findAlocacoes(String idCarteira) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idCarteira", isEqualTo: idCarteira)
          .get();
      return List.generate(snapshot.docs.length, (i) {
        return AlocacaoModel.fromMap(snapshot.docs[i].data());
      });
    } catch (e) {
      throw ApplicationException(
          'Falha ao consultar alocacoes da carteira $idCarteira! ' +
              e.toString());
    }
  }

  @override
  AlocacaoModel save(Transaction transaction, AlocacaoModel alocacaoModel) {
    try {
      DocumentReference ref;
      if (alocacaoModel.id == null) {
        ref = _db.collection(_table).doc();
        alocacaoModel.id = ref.id;
      } else {
        ref = _db.collection(_table).doc(alocacaoModel.id);
      }

      transaction.set(ref, alocacaoModel.toMap());
      return alocacaoModel;
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao salvar nova alocação! ' + e.toString());
    }
  }

  @override
  void delete(Transaction transaction, String idAlocacao) {
    try {
      DocumentReference ref = _db.collection(_table).doc(idAlocacao);
      transaction.delete(ref);
    } catch (e) {
      throw ApplicationException(
          'Falha ao salvar nova alocação! ' + e.toString());
    }
  }

  @override
  Future<void> deleteByCarteira(
      Transaction transaction, String carteiraId) async {
    try {
      QuerySnapshot query = await _db
          .collection(_table)
          .where("idCarteira", isEqualTo: carteiraId)
          .get();

      query.docs.forEach((doc) {
        transaction.delete(doc.reference);
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
}
