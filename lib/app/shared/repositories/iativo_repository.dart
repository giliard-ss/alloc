import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAtivoRepository {
  Future<List<AtivoModel>> findAtivos(String idUsuario);
  AtivoModel saveBatch(WriteBatch batch, AtivoModel ativoModel);
  void deleteBatch(WriteBatch batch, AtivoModel ativoModel);
  Future<void> deleteByCarteiraBatch(WriteBatch batch, String carteiraId);
}
