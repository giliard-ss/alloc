import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/repositories/alocacao_repository.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IAlocacaoService {
  Future<List<AlocacaoModel>> getAllAlocacoes(String usuarioId,
      {bool onlyCache});
  Future<void> update(AlocacaoModel alocacao);
  void updateBatch(WriteBatch batch, AlocacaoModel alocacao);
  void save(List<AlocacaoModel> alocacoes, bool autoAlocacao);

  void saveBatch(
      WriteBatch batch, List<AlocacaoModel> alocacoes, bool autoAlocacao);

  void delete(String idAlocacaoDeletar, List<AlocacaoModel> alocacoesUpdate,
      bool autoAlocacao);
}

class AlocacaoService implements IAlocacaoService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final IAlocacaoRepository alocacaoRepository;

  AlocacaoService({@required this.alocacaoRepository});

  @override
  void save(List<AlocacaoModel> alocacoes, bool autoAlocacao) {
    WriteBatch batch = _db.batch();
    saveBatch(batch, alocacoes, autoAlocacao);
    batch.commit();
  }

  @override
  void saveBatch(
      WriteBatch batch, List<AlocacaoModel> alocacoes, bool autoAlocacao) {
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
      alocacaoRepository.saveBatch(batch, aloc);
    }
  }

  @override
  void delete(String idAlocacaoDeletar, List<AlocacaoModel> alocacoesUpdate,
      bool autoAlocacao) {
    if (autoAlocacao) {
      double media = GeralUtil.limitaCasasDecimais(
          ((100 / alocacoesUpdate.length) / 100),
          casasDecimais: 3);
      alocacoesUpdate.forEach((a) => a.alocacao = media);
    }

    WriteBatch batch = _db.batch();

    alocacaoRepository.deleteBatch(batch, idAlocacaoDeletar);
    for (AlocacaoModel aloc in alocacoesUpdate) {
      alocacaoRepository.saveBatch(batch, aloc);
    }
    batch.commit();
  }

  @override
  Future update(AlocacaoModel alocacao) async {
    return alocacaoRepository.update(alocacao);
  }

  @override
  void updateBatch(WriteBatch batch, AlocacaoModel alocacao) {
    alocacaoRepository.updateBatch(batch, alocacao);
  }

  @override
  Future<List<AlocacaoModel>> getAllAlocacoes(String usuarioId,
      {bool onlyCache = true}) {
    return alocacaoRepository.findAlocacoes(usuarioId, onlyCache: onlyCache);
  }
}
