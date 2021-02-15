import 'package:alloc/app/shared/models/alocacao_model.dart';

abstract class IAlocacaoService {
  Future<List<AlocacaoModel>> getAllAlocacoes();
  Future update(AlocacaoModel alocacao);
  Future save(List<AlocacaoModel> alocacoes, bool autoAlocacao);
  Future<void> delete(String idAlocacaoDeletar,
      List<AlocacaoModel> alocacoesUpdate, bool autoAlocacao);
}
