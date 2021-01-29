import 'package:alloc/app/shared/models/ativo_model.dart';

abstract class IAtivoRepository {
  Future<List<AtivoModel>> findAtivos(String idUsuario);
  Future<AtivoModel> create(AtivoModel ativoModel);
  Future<void> delete(AtivoModel ativoModel);
}
