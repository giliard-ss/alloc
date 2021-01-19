import 'package:alloc/app/shared/models/alocacao_model.dart';

abstract class IAlocacaoService {
  Future<List<AlocacaoModel>> getAlocacoes(String idCarteira);
}
