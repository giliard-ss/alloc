import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAtivoRepository {
  Future<List<AtivoModel>> findAtivos(String idUsuario);
  Future<AtivoModel> create(AtivoModel ativoModel);
  Future<void> delete(AtivoModel ativoModel);
  Future<void> deleteByCarteira(Transaction transaction, String carteiraId);
}
