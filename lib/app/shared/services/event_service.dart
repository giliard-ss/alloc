import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/repositories/event_repository.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IEventService {
  Future<void> saveNovaAplicacaoVariavelFromAlocacao(
      AplicacaoRendaVariavel aplicacaoEvent, String alocacaoId, bool autoAlocacao);

  Future<void> saveNovaAplicacaoVariavelFromCarteira(
      AplicacaoRendaVariavel aplicacaoEvent, String carteiraId, bool autoAlocacao);

  Future<List<AbstractEvent>> getAllEvents();
}

class EventService implements IEventService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  IEventRepository eventRepository;
  IAtivoService ativoService;
  EventService({@required this.eventRepository, @required this.ativoService});

  @override
  Future<void> saveNovaAplicacaoVariavelFromAlocacao(
      AplicacaoRendaVariavel aplicacaoEvent, String alocacaoId, bool autoAlocacao) async {
    List<AtivoModel> allAtivosAlocacao = AppCore.getAtivosModelByIdSuperior(alocacaoId);
    allAtivosAlocacao.add(AtivoModel.fromAplicacaoRendaVariavel(aplicacaoEvent));

    return _db.runTransaction((transaction) async {
      await eventRepository.saveTransaction(transaction, aplicacaoEvent);
      await ativoService.save(allAtivosAlocacao, autoAlocacao);
    });
  }

  @override
  Future<void> saveNovaAplicacaoVariavelFromCarteira(
      AplicacaoRendaVariavel aplicacaoEvent, String carteiraId, bool autoAlocacao) {
    List<AtivoModel> allAtivosCarteira = AppCore.getAtivosModelByCarteira(carteiraId);
    allAtivosCarteira.add(AtivoModel.fromAplicacaoRendaVariavel(aplicacaoEvent));

    return _db.runTransaction((transaction) async {
      String idEvent = await eventRepository.saveTransaction(transaction, aplicacaoEvent);
      await ativoService.save(allAtivosCarteira, autoAlocacao);
      return idEvent;
    }).then((idEvent) async {
      await eventRepository.findEventById(idEvent, onlyCache: false);
    });
  }

  @override
  Future<List<AbstractEvent>> getAllEvents() {
    return eventRepository.findAllEventos(AppCore.usuario.id);
  }
}
