import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
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
  void update(CarteiraModel carteira) {
    carteiraRepository.update(carteira);
  }

  @override
  Future<void> delete(String idCarteira) async {
    List<AtivoModel> ativos = await ativoRepository.findByCarteira(idCarteira);
    List<AlocacaoModel> alocacoes =
        await alocacaoRepository.findByCarteira(idCarteira);

    WriteBatch batch = _db.batch();

    for (AtivoModel a in ativos) {
      ativoRepository.deleteBatch(batch, a);
    }

    for (AlocacaoModel a in alocacoes) {
      alocacaoRepository.deleteBatch(batch, a.id);
    }

    carteiraRepository.deleteBatch(batch, idCarteira);
    batch.commit();
  }

  @override
  void updateBatch(WriteBatch batch, CarteiraModel carteira) {
    carteiraRepository.updateBatch(batch, carteira);
  }
}
