import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAtivoService {
  Future<List<AtivoModel>> getAtivos(String usuarioId);
  Future<void> save(List<AtivoModel> ativos, bool autoAlocacao);
  void saveBatch(WriteBatch batch, List<AtivoModel> ativos, bool autoAlocacao);

  Future<void> delete(AtivoModel ativoDeletar, List<AtivoModel> ativosAtualizar,
      bool autoAlocacao);
}
