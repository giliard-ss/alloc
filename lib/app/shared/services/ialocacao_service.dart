import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAlocacaoService {
  Future<List<AlocacaoModel>> getAllAlocacoes();
  Future update(AlocacaoModel alocacao);
  void updateByTransaction(Transaction transaction, AlocacaoModel alocacao);
  Future save(List<AlocacaoModel> alocacoes, bool autoAlocacao);

  void saveByTransaction(Transaction transaction, List<AlocacaoModel> alocacoes,
      bool autoAlocacao);

  Future<void> delete(String idAlocacaoDeletar,
      List<AlocacaoModel> alocacoesUpdate, bool autoAlocacao);
}
