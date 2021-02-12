import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAlocacaoRepository {
  Future<List<AlocacaoModel>> findAlocacoes(String idUsuario);

  AlocacaoModel save(Transaction transaction, AlocacaoModel alocacaoModel);
  Future update(AlocacaoModel alocacaoModel);
  void delete(Transaction transaction, String idAlocacao);
  Future<void> deleteByCarteira(Transaction transaction, String carteiraId);
}
