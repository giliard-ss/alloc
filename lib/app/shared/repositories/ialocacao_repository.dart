import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAlocacaoRepository {
  Future<List<AlocacaoModel>> findAlocacoes(String idUsuario);
  Future<List<AlocacaoModel>> findByCarteira(String carteiraId);
  AlocacaoModel saveBatch(WriteBatch batch, AlocacaoModel alocacaoModel);
  void update(AlocacaoModel alocacaoModel);
  void updateBatch(WriteBatch batch, AlocacaoModel alocacaoModel);

  void deleteBatch(WriteBatch batch, String idAlocacao);
}
