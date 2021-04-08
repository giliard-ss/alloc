import 'package:alloc/app/shared/adapters/firebase_adapter.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/repositories/ativo_repository.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IAtivoService {
  Future<List<AtivoModel>> getAtivos(String usuarioId, {bool onlyCache});
  String saveTransaction(Transaction tr, List<AtivoModel> ativos, bool autoAlocacao);
  Future<AtivoModel> findById(String id, {bool onlyCache});
  Future<void> delete(AtivoModel ativoDeletar, List<AtivoModel> ativosAtualizar, bool autoAlocacao);
}

class AtivoService implements IAtivoService {
  IFirebaseAdapter _firebaseAdapter = new FirebaseAdapter();
  final IAtivoRepository ativoRepository;

  AtivoService({@required this.ativoRepository});

  @override
  Future<List<AtivoModel>> getAtivos(String usuarioId, {bool onlyCache = true}) {
    return ativoRepository.findAtivos(usuarioId, onlyCache: onlyCache);
  }

  @override
  String saveTransaction(Transaction tr, List<AtivoModel> ativos, bool autoAlocacao) {
    try {
      bool isAdicao = ativos.where((a) => a.id == null).isNotEmpty;
      if (isAdicao) {
        ativos = _agruparAtivos(ativos);
      }

      if (autoAlocacao) {
        double media = GeralUtil.limitaCasasDecimais((100 / ativos.length) / 100, casasDecimais: 3);
        ativos.forEach((a) => a.alocacao = media);
      } else {
        //deixa alocacao em zero se o usuario tiver configurado a alocacao
        ativos.where((e) => e.id == null).forEach((e) => e.alocacao = 0);
      }

      String idNovoAtivo;
      for (AtivoModel ativo in ativos) {
        bool ativoNovo = ativo.id == null;
        String idAtivo = ativoRepository.saveTransaction(tr, ativo);
        if (ativoNovo) idNovoAtivo = idAtivo;
      }
      return idNovoAtivo;
    } on ApplicationException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao cadastrar ativos do usuario ${ativos[0].idUsuario} ' + e.toString());
    }
  }

  _agruparAtivos(List<AtivoModel> ativos) {
    Map<String, AtivoModel> map = {};

    ativos.forEach((ativo) {
      //se o mapa ja tiver o papel, entao mantem ele e soma os valores
      if (map.containsKey(ativo.papel)) {
        AtivoModel ativoDoMap = map[ativo.papel];
        ativoDoMap.qtd = ativoDoMap.qtd + ativo.qtd;
        ativoDoMap.totalAplicado = ativoDoMap.totalAplicado + ativo.totalAplicado;
      } else {
        map[ativo.papel] = ativo;
      }
    });

    return List<AtivoModel>.from(GeralUtil.mapToList(map));
  }

  @override
  Future<void> delete(
      AtivoModel ativoDeletar, List<AtivoModel> ativosAtualizar, bool autoAlocacao) {
    if (autoAlocacao) {
      double media =
          GeralUtil.limitaCasasDecimais((100 / ativosAtualizar.length) / 100, casasDecimais: 3);
      ativosAtualizar.forEach((a) => a.alocacao = media);
    }

    return _firebaseAdapter.runTransaction((tr) async {
      ativoRepository.deleteTransaction(tr, ativoDeletar);
      for (AtivoModel ativo in ativosAtualizar) {
        ativoRepository.saveTransaction(tr, ativo);
      }
    });
  }

  @override
  Future<AtivoModel> findById(String id, {bool onlyCache = true}) {
    return ativoRepository.findById(id, onlyCache: onlyCache);
  }
}
