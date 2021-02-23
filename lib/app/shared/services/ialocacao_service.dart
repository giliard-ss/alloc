import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAlocacaoService {
  Future<List<AlocacaoModel>> getAllAlocacoes();
  Future<void> update(AlocacaoModel alocacao);
  void updateBatch(WriteBatch batch, AlocacaoModel alocacao);
  void save(List<AlocacaoModel> alocacoes, bool autoAlocacao);

  void saveBatch(
      WriteBatch batch, List<AlocacaoModel> alocacoes, bool autoAlocacao);

  void delete(String idAlocacaoDeletar, List<AlocacaoModel> alocacoesUpdate,
      bool autoAlocacao);
}
