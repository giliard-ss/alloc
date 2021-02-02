import 'package:alloc/app/shared/models/ativo_model.dart';

abstract class IAtivoService {
  Future<List<AtivoModel>> getAtivos(String usuarioId);
  Future save(List<AtivoModel> ativos);
  Future<void> delete(AtivoModel ativoModel);
}
