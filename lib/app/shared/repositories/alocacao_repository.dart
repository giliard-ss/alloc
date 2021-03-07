import 'package:alloc/app/shared/config/cf_settings.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAlocacaoRepository {
  Future<List<AlocacaoModel>> findAlocacoes(String idUsuario, {bool onlyCache});
  Future<List<AlocacaoModel>> findByCarteira(String carteiraId,
      {bool onlyCache});
  AlocacaoModel saveBatch(WriteBatch batch, AlocacaoModel alocacaoModel);
  void update(AlocacaoModel alocacaoModel);
  void updateBatch(WriteBatch batch, AlocacaoModel alocacaoModel);
  void deleteBatch(WriteBatch batch, String idAlocacao);
}

class AlocacaoRepository implements IAlocacaoRepository {
  static final _table = "alocacoes";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<AlocacaoModel>> findAlocacoes(String idUsuario,
      {bool onlyCache = true}) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idUsuario", isEqualTo: idUsuario)
          .get(await CfSettrings.getOptions(onlyCache: onlyCache));
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
  Future<List<AlocacaoModel>> findByCarteira(String carteiraId,
      {bool onlyCache = true}) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idCarteira", isEqualTo: carteiraId)
          .get(await CfSettrings.getOptions(onlyCache: onlyCache));
      return List.generate(snapshot.docs.length, (i) {
        return AlocacaoModel.fromMap(snapshot.docs[i].data());
      });
    } catch (e) {
      throw ApplicationException(
          'Falha ao consultar alocacoes da carteira $carteiraId! ' +
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
  void update(AlocacaoModel alocacaoModel) {
    try {
      _db.collection(_table).doc(alocacaoModel.id).set(alocacaoModel.toMap());
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
