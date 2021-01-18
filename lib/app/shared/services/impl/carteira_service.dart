import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/repositories/impl/carteira_repository.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:flutter/material.dart';

class CarteiraService implements ICarteiraService {
  final CarteiraRepository carteiraRepository;
  CarteiraService({@required this.carteiraRepository});

  @override
  Future<List<CarteiraModel>> getCarteiras(String usuarioId) {
    return carteiraRepository.findCarteiras(usuarioId);
  }
}
