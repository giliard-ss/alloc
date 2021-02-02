import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/repositories/ialocacao_repository.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlocacaoService implements IAlocacaoService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final IAlocacaoRepository alocacaoRepository;

  AlocacaoService({@required this.alocacaoRepository});

  @override
  Future<List<AlocacaoModel>> getAlocacoes(String idCarteira) {
    return alocacaoRepository.findAlocacoes(idCarteira);
  }

  @override
  Future save(List<AlocacaoModel> alocacoes) async {
    return _db.runTransaction(
      (transaction) async {
        for (AlocacaoModel aloc in alocacoes) {
          alocacaoRepository.save(transaction, aloc);
        }
      },
    );
  }

  @override
  Future<void> delete(
      String idAlocacaoDeletar, List<AlocacaoModel> alocacoesUpdate) {
    return _db.runTransaction(
      (transaction) async {
        alocacaoRepository.delete(transaction, idAlocacaoDeletar);
        for (AlocacaoModel aloc in alocacoesUpdate) {
          alocacaoRepository.save(transaction, aloc);
        }
      },
    );
  }
}
