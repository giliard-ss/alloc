import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ICarteiraService {
  Future<List<CarteiraModel>> getCarteiras(String usuarioId);
  Future<void> create(String descricao);
  Future<void> update(CarteiraModel carteira);
  void updateByTransaction(Transaction transaction, CarteiraModel carteira);
  Future<void> delete(String idCarteira);
}
