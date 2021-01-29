import 'package:alloc/app/shared/models/alocacao_model.dart';

abstract class IAlocacaoService {
  Future<List<AlocacaoModel>> getAlocacoes(String idCarteira);
  Future<AlocacaoModel> create(
      String descricao, String idCarteira, String idSuperior);
  Future<void> delete(String idAlocacao);
}
