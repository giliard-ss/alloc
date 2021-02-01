import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/repositories/impl/alocacao_repository.dart';
import 'package:alloc/app/shared/repositories/impl/ativo_repository.dart';
import 'package:alloc/app/shared/repositories/impl/carteira_repository.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  Future<List<CarteiraModel>> getCarteiras(String usuarioId) {
    return carteiraRepository.findCarteiras(usuarioId);
  }

  @override
  Future<void> create(String descricao) async {
    await carteiraRepository.create(SharedMain.usuario.id, descricao);
  }

  @override
  Future<void> update(CarteiraModel carteira) {
    return carteiraRepository.update(carteira);
  }

  @override
  Future<void> delete(String idCarteira) async {
    return _db.runTransaction((transaction) async {
      await ativoRepository.deleteByCarteira(transaction, idCarteira);
      await alocacaoRepository.deleteByCarteira(transaction, idCarteira);
      carteiraRepository.delete(transaction, idCarteira);
    });
  }
}
