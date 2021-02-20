import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/repositories/impl/alocacao_repository.dart';
import 'package:alloc/app/shared/repositories/impl/ativo_repository.dart';
import 'package:alloc/app/shared/repositories/impl/carteira_repository.dart';
import 'package:alloc/app/shared/services/icarteira_service.dart';
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
    await carteiraRepository.create(AppCore.usuario.id, descricao);
  }

  @override
  Future<void> update(CarteiraModel carteira) {
    return carteiraRepository.update(carteira);
  }

  @override
  Future<void> delete(String idCarteira) async {
    WriteBatch batch = _db.batch();
    await ativoRepository.deleteByCarteiraBatch(batch, idCarteira);
    await alocacaoRepository.deleteByCarteiraBatch(batch, idCarteira);
    carteiraRepository.deleteBatch(batch, idCarteira);
    return batch.commit();
  }

  @override
  void updateBatch(WriteBatch batch, CarteiraModel carteira) {
    carteiraRepository.updateBatch(batch, carteira);
  }
}
