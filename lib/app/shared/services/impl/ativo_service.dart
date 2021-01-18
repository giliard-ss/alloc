import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/repositories/iativo_repository.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:flutter/material.dart';

class AtivoService implements IAtivoService {
  final IAtivoRepository ativoRepository;

  AtivoService({@required this.ativoRepository});

  @override
  Future<List<AtivoModel>> getAtivos(String usuarioId) {
    return ativoRepository.findAtivos(usuarioId);
  }
}
