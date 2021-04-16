import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/adapters/firebase_adapter.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/evento_deposito.dart';
import 'package:alloc/app/shared/models/evento_provento.dart';
import 'package:alloc/app/shared/models/evento_saque.dart';
import 'package:alloc/app/shared/models/evento_venda.dart';
import 'package:alloc/app/shared/models/evento_venda_renda_variavel.dart';
import 'package:alloc/app/shared/repositories/alocacao_repository.dart';
import 'package:alloc/app/shared/repositories/ativo_repository.dart';
import 'package:alloc/app/shared/repositories/carteira_repository.dart';
import 'package:alloc/app/shared/repositories/event_repository.dart';
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
  Future<List<CarteiraModel>> getCarteiras(String usuarioId, {bool onlyCache = true}) async {
    List<CarteiraModel> carteiras =
        await carteiraRepository.findCarteiras(usuarioId, onlyCache: onlyCache);

    for (CarteiraModel carteira in carteiras) {
      double totalDepositos = await _getTotalDepositadoCarteira(carteira);
      double totalSaques = await _getTotalSacadoCarteira(carteira);
      double totalProventos = await _getTotalProventosCarteira(carteira);
      double totalLucroVendas = await _getTotalLucroVendasCarteira(carteira);

      carteira.totalDeposito = totalDepositos - totalSaques;
      carteira.totalLucroVendas = totalLucroVendas;
      carteira.totalProventos = totalProventos;
    }

    return carteiras;
  }

  Future<double> _getTotalDepositadoCarteira(CarteiraModel carteiraModel) async {
    List<AbstractEvent> depositos = await eventRepository.getEventsByTipoAndCarteira(
        carteiraModel.idUsuario, EventoDeposito.name, carteiraModel.id);

    double total = 0;
    depositos.forEach((e) {
      EventoDeposito deposito = e;
      total += deposito.valor;
    });
    return total;
  }

  Future<double> _getTotalSacadoCarteira(CarteiraModel carteiraModel) async {
    List<AbstractEvent> saques = await eventRepository.getEventsByTipoAndCarteira(
        carteiraModel.idUsuario, EventoSaque.name, carteiraModel.id);

    double total = 0;
    saques.forEach((e) {
      EventoSaque saque = e;
      total += saque.valor;
    });
    return total;
  }

  Future<double> _getTotalLucroVendasCarteira(CarteiraModel carteiraModel) async {
    List<AbstractEvent> vendas = await eventRepository.getEventsByTipoAndCarteira(
        carteiraModel.idUsuario, EventoVenda.name, carteiraModel.id);

    double total = 0;
    vendas.forEach((e) {
      if (e is VendaRendaVariavelEvent) total += e.lucro;
    });
    return total;
  }

  Future<double> _getTotalProventosCarteira(CarteiraModel carteiraModel) async {
    List<AbstractEvent> proventos = await eventRepository.getEventsByTipoAndCarteira(
        carteiraModel.idUsuario, EventoProvento.name, carteiraModel.id);

    double total = 0;
    proventos.forEach((e) {
      EventoProvento provento = e;
      total += provento.valor;
    });
    return total;
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
      eventRepository.deleteTransactionByCarteira(transaction, idCarteira);

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
