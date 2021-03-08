import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/repositories/alocacao_repository.dart';
import 'package:alloc/app/shared/repositories/ativo_repository.dart';
import 'package:alloc/app/shared/repositories/carteira_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class ICarteiraService {
  Future<List<CarteiraModel>> getCarteiras(String usuarioId, {bool onlyCache});
  Future<void> create(String descricao);
  Future<void> update(CarteiraModel carteira);
  Future<void> updateTransaction(Transaction tr, CarteiraModel carteira);
  Future<void> delete(String idCarteira);
}

class CarteiraService implements ICarteiraService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final CarteiraRepository carteiraRepository;
  final AtivoRepository ativoRepository;
  final AlocacaoRepository alocacaoRepository;
  CarteiraService(
      {@required this.carteiraRepository,
      @required this.ativoRepository,
      @required this.alocacaoRepository});

  @override
  Future<List<CarteiraModel>> getCarteiras(String usuarioId,
      {bool onlyCache = true}) {
    return carteiraRepository.findCarteiras(usuarioId, onlyCache: onlyCache);
  }

  @override
  Future<void> create(String descricao) {
    return carteiraRepository.create(AppCore.usuario.id, descricao);
  }

  @override
  Future<void> update(CarteiraModel carteira) {
    return carteiraRepository.update(carteira);
  }

  @override
  Future<void> delete(String idCarteira) async {
    List<AtivoModel> ativos = await ativoRepository.findByCarteira(idCarteira);
    List<AlocacaoModel> alocacoes =
        await alocacaoRepository.findByCarteira(idCarteira);

    return _db.runTransaction((tr) async {
      for (AtivoModel a in ativos) {
        ativoRepository.deleteTransaction(tr, a);
      }

      for (AlocacaoModel a in alocacoes) {
        alocacaoRepository.deleteTransaction(tr, a.id);
      }

      carteiraRepository.deleteTransaction(tr, idCarteira);
    });
  }

  @override
  Future<void> updateTransaction(Transaction tr, CarteiraModel carteira) {
    return carteiraRepository.updateTransaction(tr, carteira);
  }
}
