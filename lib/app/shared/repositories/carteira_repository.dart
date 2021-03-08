import 'package:alloc/app/shared/config/cf_settings.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/utils/connection_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ICarteiraRepository {
  Future<List<CarteiraModel>> findCarteiras(String idUsuario, {bool onlyCache});
  Future<CarteiraModel> create(String idUsuario, String descricao);
  Future<void> update(CarteiraModel carteira);
  Future<void> updateTransaction(Transaction tr, CarteiraModel carteira);
  Future<void> deleteTransaction(Transaction tr, String idCarteira);
}

class CarteiraRepository implements ICarteiraRepository {
  static final _table = "carteiras";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<CarteiraModel>> findCarteiras(String idUsuario,
      {bool onlyCache = true}) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_table)
          .where("idUsuario", isEqualTo: idUsuario)
          .get(await CfSettrings.getOptions(onlyCache: onlyCache));
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
    await ConnectionUtil.checkConnection();
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
    await ConnectionUtil.checkConnection();
    try {
      await _db.collection(_table).doc(carteira.id).set(carteira.toMap());
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao atualizar a carteira ${carteira.id}! ' + e.toString());
    }
  }

  @override
  Future<void> deleteTransaction(Transaction tr, String idCarteira) async {
    await ConnectionUtil.checkConnection();
    try {
      DocumentReference ref = _db.collection(_table).doc(idCarteira);
      tr.delete(ref);
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao deletar carteira $idCarteira! ' + e.toString());
    }
  }

  @override
  Future<void> updateTransaction(Transaction tr, CarteiraModel carteira) async {
    await ConnectionUtil.checkConnection();
    try {
      DocumentReference ref = _db.collection(_table).doc(carteira.id);
      tr.set(ref, carteira.toMap());
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao atualizar a carteira ${carteira.id}! ' + e.toString());
    }
  }
}
