import 'package:alloc/app/shared/models/carteira_model.dart';

abstract class ICarteiraService {
  Future<List<CarteiraModel>> getCarteiras(String usuarioId);
  Future<void> create(String descricao);
  Future<void> update(CarteiraModel carteira);
  Future<void> delete(String idCarteira);
}
