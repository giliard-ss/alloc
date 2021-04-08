import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/adapters/firebase_adapter.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/repositories/alocacao_repository.dart';
import 'package:alloc/app/shared/repositories/ativo_repository.dart';
import 'package:alloc/app/shared/repositories/carteira_repository.dart';
import 'package:alloc/app/shared/repositories/event_repository.dart';
import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class ICarteiraService {
  Future<List<CarteiraModel>> getCarteiras(String usuarioId, {bool onlyCache});
  Future<void> create(String descricao);
  Future<void> update(CarteiraModel carteira);
  void updateTransaction(Transaction tr, CarteiraModel carteira);
  Future<void> delete(String idCarteira);
}

class CarteiraService implements ICarteiraService {
  IFirebaseAdapter _firebaseAdapter = new FirebaseAdapter();
  final CarteiraRepository carteiraRepository;
  final AtivoRepository ativoRepository;
  final AlocacaoRepository alocacaoRepository;
  final EventRepository eventRepository;
  CarteiraService(
      {@required this.carteiraRepository,
      @required this.ativoRepository,
      @required this.alocacaoRepository,
      @required this.eventRepository});

  @override
  Future<List<CarteiraModel>> getCarteiras(String usuarioId, {bool onlyCache = true}) {
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
    //List<AtivoModel> ativos = await ativoRepository.findByCarteira(idCarteira);
    List<AlocacaoModel> alocacoes = await alocacaoRepository.findByCarteira(idCarteira);

    return _firebaseAdapter.runTransaction((Transaction transaction) async {
      /*for (AtivoModel a in ativos) {
        ativoRepository.deleteTransaction(tr, a);
      }*/
      eventRepository.deleteByTransactionAndCarteiraId(transaction, idCarteira);

      for (AlocacaoModel a in alocacoes) {
        alocacaoRepository.deleteTransaction(transaction, a.id);
      }

      carteiraRepository.deleteTransaction(transaction, idCarteira);
    });
  }

  @override
  void updateTransaction(Transaction tr, CarteiraModel carteira) {
    carteiraRepository.updateTransaction(tr, carteira);
  }
}
