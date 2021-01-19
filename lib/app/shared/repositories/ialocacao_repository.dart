import 'package:alloc/app/shared/models/alocacao_model.dart';

abstract class IAlocacaoRepository {
  Future<List<AlocacaoModel>> findAlocacoes(String idCarteira);
}
