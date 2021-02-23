import 'package:alloc/app/shared/exceptions/application_exception.dart';
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
  void save(List<AtivoModel> ativos, bool autoAlocacao) {
    WriteBatch batch = _db.batch();
    saveBatch(batch, ativos, autoAlocacao);
    batch.commit();
  }

  @override
  void saveBatch(WriteBatch batch, List<AtivoModel> ativos, bool autoAlocacao) {
    try {
      List<AtivoModel> list = ativos;
      bool isAdicao = ativos.where((a) => a.id == null).isNotEmpty;
      if (isAdicao) {
        list = _agruparAtivos(ativos);
      }

      if (autoAlocacao) {
        double media = GeralUtil.limitaCasasDecimais((100 / list.length) / 100,
            casasDecimais: 3);
        list.forEach((a) => a.alocacao = media);
      } else {
        //deixa alocacao em zero se o usuario tiver configurado a alocacao
        list.where((e) => e.id == null).forEach((e) => e.alocacao = 0);
      }

      for (AtivoModel ativo in list) {
        ativoRepository.saveBatch(batch, ativo);
      }
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao cadastrar ativos do usuario ${ativos[0].idUsuario} ' +
              e.toString());
    }
  }

  _agruparAtivos(List<AtivoModel> ativos) {
    Map<String, AtivoModel> map = {};

    ativos.forEach((a) {
      //se o mapa ja tiver o papel, entao mantem ele e soma os valores
      if (map.containsKey(a.papel)) {
        double qtdTotal = map[a.papel].qtd + a.qtd;
        double mediaPreco =
            (map[a.papel].totalAportado + a.totalAportado) / qtdTotal;

        map[a.papel].preco =
            GeralUtil.limitaCasasDecimais(mediaPreco, casasDecimais: 3);
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
  void delete(AtivoModel ativoDeletar, List<AtivoModel> ativosAtualizar,
      bool autoAlocacao) {
    if (autoAlocacao) {
      double media = GeralUtil.limitaCasasDecimais(
          (100 / ativosAtualizar.length) / 100,
          casasDecimais: 3);
      ativosAtualizar.forEach((a) => a.alocacao = media);
    }
    WriteBatch batch = _db.batch();

    ativoRepository.deleteBatch(batch, ativoDeletar);
    for (AtivoModel ativo in ativosAtualizar) {
      ativoRepository.saveBatch(batch, ativo);
    }
    batch.commit();
  }
}
