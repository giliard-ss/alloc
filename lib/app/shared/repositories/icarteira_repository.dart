import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ICarteiraRepository {
  Future<List<CarteiraModel>> findCarteiras(String idUsuario);
  Future<CarteiraModel> create(String idUsuario, String descricao);
  Future<void> update(CarteiraModel carteira);
  void updateBatch(WriteBatch batch, CarteiraModel carteira);

  void deleteBatch(WriteBatch batch, String idCarteira);
}
