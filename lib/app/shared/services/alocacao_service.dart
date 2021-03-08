import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/repositories/alocacao_repository.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IAlocacaoService {
  Future<List<AlocacaoModel>> getAllAlocacoes(String usuarioId,
      {bool onlyCache});
  Future<void> update(AlocacaoModel alocacao);
  Future<void> updateTransaction(Transaction tr, AlocacaoModel alocacao);
  Future<void> save(List<AlocacaoModel> alocacoes, bool autoAlocacao);

  Future<void> saveTransaction(
      Transaction tr, List<AlocacaoModel> alocacoes, bool autoAlocacao);

  Future<void> delete(String idAlocacaoDeletar,
      List<AlocacaoModel> alocacoesUpdate, bool autoAlocacao);
}

class AlocacaoService implements IAlocacaoService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final IAlocacaoRepository alocacaoRepository;

  AlocacaoService({@required this.alocacaoRepository});

  @override
  Future<void> save(List<AlocacaoModel> alocacoes, bool autoAlocacao) async {
    return _db.runTransaction((tr) async {
      await saveTransaction(tr, alocacoes, autoAlocacao);
    });
  }

  @override
  Future<void> saveTransaction(
      Transaction tr, List<AlocacaoModel> alocacoes, bool autoAlocacao) async {
    if (autoAlocacao) {
      double media = GeralUtil.limitaCasasDecimais(
          ((100 / alocacoes.length) / 100),
          casasDecimais: 3);
      alocacoes.forEach((a) => a.alocacao = media);
    } else {
      //novas alocacoes recebem zero se a alocacao nao for automatica, usuario configura
      alocacoes.where((e) => e.id == null).forEach((e) => e.alocacao = 0);
    }

    for (AlocacaoModel aloc in alocacoes) {
      await alocacaoRepository.saveTransaction(tr, aloc);
    }
  }

  @override
  Future<void> delete(String idAlocacaoDeletar,
      List<AlocacaoModel> alocacoesUpdate, bool autoAlocacao) async {
    if (autoAlocacao) {
      double media = GeralUtil.limitaCasasDecimais(
          ((100 / alocacoesUpdate.length) / 100),
          casasDecimais: 3);
      alocacoesUpdate.forEach((a) => a.alocacao = media);
    }

    return _db.runTransaction((tr) async {
      await alocacaoRepository.deleteTransaction(tr, idAlocacaoDeletar);
      for (AlocacaoModel aloc in alocacoesUpdate) {
        await alocacaoRepository.saveTransaction(tr, aloc);
      }
    });
  }

  @override
  Future<void> update(AlocacaoModel alocacao) {
    return alocacaoRepository.update(alocacao);
  }

  @override
  Future<void> updateTransaction(Transaction tr, AlocacaoModel alocacao) {
    return alocacaoRepository.updateTransaction(tr, alocacao);
  }

  @override
  Future<List<AlocacaoModel>> getAllAlocacoes(String usuarioId,
      {bool onlyCache = true}) {
    return alocacaoRepository.findAlocacoes(usuarioId, onlyCache: onlyCache);
  }
}
