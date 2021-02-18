import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IAtivoService {
  Future<List<AtivoModel>> getAtivos(String usuarioId);
  Future save(List<AtivoModel> ativos, bool autoAlocacao);
  void saveByTransaction(
      Transaction transaction, List<AtivoModel> ativos, bool autoAlocacao);

  Future delete(AtivoModel ativoDeletar, List<AtivoModel> ativosAtualizar,
      bool autoAlocacao);
}
