import 'package:alloc/app/shared/models/abstract_event.dart';
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

  Future<List<AbstractEvent>> getAllEvents(String usuarioId, {bool onlyCache});
}

class EventService implements IEventService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  IEventRepository eventRepository;
  IAtivoService ativoService;
  EventService({@required this.eventRepository, @required this.ativoService});

  @override
  Future<void> saveNovaAplicacaoVariavelFromAlocacao(
      AplicacaoRendaVariavel aplicacaoEvent, String alocacaoId, bool autoAlocacao) {
    return eventRepository.save(aplicacaoEvent);
  }

  @override
  Future<void> saveNovaAplicacaoVariavelFromCarteira(
      AplicacaoRendaVariavel aplicacaoEvent, String carteiraId, bool autoAlocacao) {
    return eventRepository.save(aplicacaoEvent);
  }

  @override
  Future<List<AbstractEvent>> getAllEvents(String usuarioId, {bool onlyCache = true}) {
    return eventRepository.findAllEventos(usuarioId, onlyCache: onlyCache);
  }
}
