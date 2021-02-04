import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/repositories/iativo_repository.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
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
  Future save(List<AtivoModel> ativos, bool autoAlocacao) async {
    List<AtivoModel> list = ativos;
    bool isAdicao = ativos.where((a) => a.id == null).isNotEmpty;
    if (isAdicao) {
      list = _agruparAtivos(ativos);
    }

    if (autoAlocacao) {
      double media = GeralUtil.limitaCasasDecimais((100 / list.length) / 100);
      list.forEach((a) => a.alocacao = media);
    } else {
      //deixa alocacao em zero se o usuario tiver configurado a alocacao
      list.where((e) => e.id == null).forEach((e) => e.alocacao = 0);
    }

    return _db.runTransaction(
      (transaction) async {
        for (AtivoModel ativo in list) {
          ativoRepository.save(transaction, ativo);
        }
      },
    );
  }

  _agruparAtivos(List<AtivoModel> ativos) {
    Map<String, AtivoModel> map = {};

    ativos.forEach((a) {
      //se o mapa ja tiver o papel, entao mantem ele e soma os valores
      if (map.containsKey(a.papel)) {
        double mediaPreco = GeralUtil.limitaCasasDecimais(
            ((map[a.papel].preco.toDouble() + a.preco.toDouble()) / 2));
        map[a.papel].preco = mediaPreco;
        map[a.papel].qtd = map[a.papel].qtd + a.qtd;
        map[a.papel].data =
            map[a.papel].data.isAfter(a.data) ? map[a.papel].data : a.data;
      } else {
        map[a.papel] = a;
      }
    });

    return List<AtivoModel>.from(GeralUtil.mapToList(map));
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
