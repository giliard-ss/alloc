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
  Future<AlocacaoModel> create(
      String descricao, String idCarteira, String idSuperior) async {
    DocumentReference ref = _db.collection(_table).doc();
    AlocacaoModel alocacao =
        AlocacaoModel(ref.id, descricao, null, idCarteira, idSuperior);

    await _db.runTransaction((transaction) async {
      transaction.set(ref, alocacao.toMap());
    }).catchError((e) {
      throw ApplicationException(
          'Falha ao salvar nova alocação! ' + e.toString());
    }).then((e) {
      return alocacao;
    });
  }

  @override
  Future<void> delete(String idAlocacao) {
    try {
      return _db.collection(_table).doc(idAlocacao).delete();
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
}
