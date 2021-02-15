import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/repositories/ialocacao_repository.dart';
import 'package:alloc/app/shared/services/ialocacao_service.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlocacaoService implements IAlocacaoService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final IAlocacaoRepository alocacaoRepository;

  AlocacaoService({@required this.alocacaoRepository});

  @override
  Future save(List<AlocacaoModel> alocacoes, bool autoAlocacao) async {
    if (autoAlocacao) {
      double media = GeralUtil.limitaCasasDecimais(
          ((100 / alocacoes.length) / 100),
          casasDecimais: 3);
      alocacoes.forEach((a) => a.alocacao = media);
    } else {
      //novas alocacoes recebem zero se a alocacao nao for automatica, usuario configura
      alocacoes.where((e) => e.id == null).forEach((e) => e.alocacao = 0);
    }

    return _db.runTransaction(
      (transaction) async {
        for (AlocacaoModel aloc in alocacoes) {
          alocacaoRepository.save(transaction, aloc);
        }
      },
    );
  }

  @override
  Future<void> delete(String idAlocacaoDeletar,
      List<AlocacaoModel> alocacoesUpdate, bool autoAlocacao) {
    if (autoAlocacao) {
      double media = GeralUtil.limitaCasasDecimais(
          ((100 / alocacoesUpdate.length) / 100),
          casasDecimais: 3);
      alocacoesUpdate.forEach((a) => a.alocacao = media);
    }

    return _db.runTransaction(
      (transaction) async {
        alocacaoRepository.delete(transaction, idAlocacaoDeletar);
        for (AlocacaoModel aloc in alocacoesUpdate) {
          alocacaoRepository.save(transaction, aloc);
        }
      },
    );
  }

  @override
  Future update(AlocacaoModel alocacao) {
    return alocacaoRepository.update(alocacao);
  }

  @override
  Future<List<AlocacaoModel>> getAllAlocacoes() {
    return alocacaoRepository.findAlocacoes(AppCore.usuario.id);
  }
}
