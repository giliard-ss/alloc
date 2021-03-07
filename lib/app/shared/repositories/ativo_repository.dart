import 'package:alloc/app/shared/config/cf_settings.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAtivoRepository {
  Future<List<AtivoModel>> findAtivos(String idUsuario, {onlyCache});
  Future<List<AtivoModel>> findByCarteira(String carteiraId, {onlyCache});

  AtivoModel saveBatch(WriteBatch batch, AtivoModel ativoModel);
  void deleteBatch(WriteBatch batch, AtivoModel ativoModel);
}

class AtivoRepository implements IAtivoRepository {
  static final _table = "ativos";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<AtivoModel>> findAtivos(String idUsuario,
      {onlyCache = true}) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idUsuario", isEqualTo: idUsuario)
          .get(await CfSettrings.getOptions(onlyCache: onlyCache));
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
  Future<List<AtivoModel>> findByCarteira(String carteiraId,
      {onlyCache = true}) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idCarteira", isEqualTo: carteiraId)
          .get(await CfSettrings.getOptions(onlyCache: onlyCache));
      return List.generate(snapshot.docs.length, (i) {
        return AtivoModel.fromMap(snapshot.docs[i].data());
      });
    } catch (e) {
      throw ApplicationException(
          'Falha ao consultar os ativos da carteira $carteiraId! ' +
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
}
