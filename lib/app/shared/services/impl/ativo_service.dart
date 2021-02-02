import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/repositories/iativo_repository.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AtivoService implements IAtivoService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final IAtivoRepository ativoRepository;

  AtivoService({@required this.ativoRepository});

  @override
  Future<List<AtivoModel>> getAtivos(String usuarioId) {
    return ativoRepository.findAtivos(usuarioId);
  }

  @override
  Future save(List<AtivoModel> ativos) async {
    return _db.runTransaction(
      (transaction) async {
        for (AtivoModel ativo in ativos) {
          ativoRepository.save(transaction, ativo);
        }
      },
    );
  }

  @override
  Future delete(
      AtivoModel ativoDeletar, List<AtivoModel> ativosAtualizar) async {
    return _db.runTransaction(
      (transaction) async {
        ativoRepository.delete(transaction, ativoDeletar);
        for (AtivoModel ativo in ativosAtualizar) {
          ativoRepository.save(transaction, ativo);
        }
      },
    );
  }
}
