import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAlocacaoRepository {
  Future<List<AlocacaoModel>> findAlocacoes(String idUsuario);

  AlocacaoModel saveBatch(WriteBatch batch, AlocacaoModel alocacaoModel);
  Future<void> update(AlocacaoModel alocacaoModel);
  void updateBatch(WriteBatch batch, AlocacaoModel alocacaoModel);

  void deleteBatch(WriteBatch batch, String idAlocacao);
  Future<void> deleteByCarteiraBatch(WriteBatch batch, String carteiraId);
}
