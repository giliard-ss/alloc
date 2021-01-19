import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/repositories/ialocacao_repository.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:flutter/material.dart';

class AlocacaoService implements IAlocacaoService {
  final IAlocacaoRepository alocacaoRepository;

  AlocacaoService({@required this.alocacaoRepository});

  @override
  Future<List<AlocacaoModel>> getAlocacoes(String idCarteira) {
    return alocacaoRepository.findAlocacoes(idCarteira);
  }
}
