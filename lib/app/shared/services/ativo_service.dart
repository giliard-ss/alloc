import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/repositories/ativo_repository.dart';
import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IAtivoService {
  Future<List<AtivoModel>> getAtivos(String usuarioId, {bool onlyCache});
  Future<void> save(List<AtivoModel> ativos, bool autoAlocacao);
  Future<void> saveTransaction(
      Transaction tr, List<AtivoModel> ativos, bool autoAlocacao);
  Future<void> delete(AtivoModel ativoDeletar, List<AtivoModel> ativosAtualizar,
      bool autoAlocacao);
}

class AtivoService implements IAtivoService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final IAtivoRepository ativoRepository;

  AtivoService({@required this.ativoRepository});

  @override
  Future<List<AtivoModel>> getAtivos(String usuarioId,
      {bool onlyCache = true}) {
    return ativoRepository.findAtivos(usuarioId, onlyCache: onlyCache);
  }

  @override
  Future<void> save(List<AtivoModel> ativos, bool autoAlocacao) {
    return _db.runTransaction((tr) {
      return saveTransaction(tr, ativos, autoAlocacao);
    });
  }

  @override
  Future<void> saveTransaction(
      Transaction tr, List<AtivoModel> ativos, bool autoAlocacao) async {
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
        await ativoRepository.saveTransaction(tr, ativo);
      }
    } on ApplicationException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw ApplicationException(
          'Falha ao cadastrar ativos do usuario ${ativos[0].idUsuario} ' +
              e.toString());
    }
  }

  _agruparAtivos(List<AtivoModel> ativos) {
    Map<String, AtivoModel> map = {};
    List<AtivoModel> list = _agruparAtivosMesmaData(ativos);

    list.forEach((a) {
      //se o mapa ja tiver o papel, entao mantem ele e soma os valores
      if (map.containsKey(a.papel)) {
        double qtdTotal = map[a.papel].qtd + a.qtd;
        double mediaPreco =
            (map[a.papel].totalAportado + a.totalAportado) / qtdTotal;

        map[a.papel].precoMedio =
            GeralUtil.limitaCasasDecimais(mediaPreco, casasDecimais: 3);
        map[a.papel].qtd = map[a.papel].qtd + a.qtd;
        map[a.papel].dataRecente =
            map[a.papel].dataRecente.isAfter(a.dataRecente)
                ? map[a.papel].dataRecente
                : a.dataRecente;

        map[a.papel].precoRecente =
            map[a.papel].dataRecente.isAfter(a.dataRecente)
                ? map[a.papel].precoRecente
                : a.precoRecente;
      } else {
        a.precoRecente = a.precoMedio;
        map[a.papel] = a;
      }
    });

    return List<AtivoModel>.from(GeralUtil.mapToList(map));
  }

  List<AtivoModel> _agruparAtivosMesmaData(List<AtivoModel> ativos) {
    Map<String, AtivoModel> map = {};

    ativos.forEach((a) {
      String key = a.papel + DateUtil.dateToString(a.dataRecente);

      if (map.containsKey(key)) {
        double qtdTotal = map[key].qtd + a.qtd;
        double mediaPreco =
            (map[key].totalAportado + a.totalAportado) / qtdTotal;

        map[key].precoMedio =
            GeralUtil.limitaCasasDecimais(mediaPreco, casasDecimais: 3);
        map[key].qtd = qtdTotal;

        map[key].precoRecente =
            GeralUtil.limitaCasasDecimais(mediaPreco, casasDecimais: 3);
      } else {
        map[key] = a;
      }
    });

    return List<AtivoModel>.from(GeralUtil.mapToList(map));
  }

  @override
  Future<void> delete(AtivoModel ativoDeletar, List<AtivoModel> ativosAtualizar,
      bool autoAlocacao) {
    if (autoAlocacao) {
      double media = GeralUtil.limitaCasasDecimais(
          (100 / ativosAtualizar.length) / 100,
          casasDecimais: 3);
      ativosAtualizar.forEach((a) => a.alocacao = media);
    }

    return _db.runTransaction((tr) async {
      await ativoRepository.deleteTransaction(tr, ativoDeletar);
      for (AtivoModel ativo in ativosAtualizar) {
        await ativoRepository.saveTransaction(tr, ativo);
      }
    });
  }
}
