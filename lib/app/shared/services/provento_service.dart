import 'package:alloc/app/shared/models/provento_model.dart';
import 'package:alloc/app/shared/repositories/provento_repository.dart';
import 'package:flutter/material.dart';

abstract class IProventoService {
  Future<List<ProventoModel>> findProventos(DateTime inicio, {onlyCache});
  Future<ProventoModel> findUltimoProventoOrNullAposData(DateTime data, {onlyCache});
}

class ProventoService implements IProventoService {
  IProventoRepository proventoRepository;

  ProventoService({@required this.proventoRepository});

  @override
  Future<List<ProventoModel>> findProventos(DateTime inicio, {onlyCache = true}) {
    return proventoRepository.findProventos(inicio, onlyCache: onlyCache);
  }

  @override
  Future<ProventoModel> findUltimoProventoOrNullAposData(DateTime data, {onlyCache = true}) {
    return proventoRepository.findUltimoProventoOrNullAposData(data, onlyCache: onlyCache);
  }
}
