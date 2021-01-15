import 'package:alloc/app/shared/models/carteira_model.dart';

abstract class ICarteiraRepository {
  Future<List<CarteiraModel>> findCarteiras(String idUsuario);
}
