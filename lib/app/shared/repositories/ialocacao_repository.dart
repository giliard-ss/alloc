import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAlocacaoRepository {
  Future<List<AlocacaoModel>> findAlocacoes(String idCarteira);
  Future<AlocacaoModel> create(
      String descricao, String idCarteira, String idSuperior);
  Future<void> delete(String idAlocacao);
  Future<void> deleteByCarteira(Transaction transaction, String carteiraId);
}
