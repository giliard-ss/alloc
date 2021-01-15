import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/repositories/impl/carteira_repository.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:flutter/cupertino.dart';

class CarteiraService implements ICarteiraService {
  static final String user = "gss";
  final CarteiraRepository carteiraRepository;

  CarteiraService({@required this.carteiraRepository});

  @override
  Future<List<CarteiraModel>> getCarteiras() {
    return carteiraRepository.findCarteiras(user);
  }
}
