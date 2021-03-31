import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/repositories/event_repository.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IEventService {
  Future<void> saveAplicacaoRendaVariavel(AplicacaoRendaVariavel aplicacaoEvent);
  Future<List<AbstractEvent>> getAllEvents(String usuarioId, {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByPeriodo(String usuarioId, DateTime inicio, DateTime fim,
      {bool onlyCache});
  Future<void> delete(AbstractEvent event);
}

class EventService implements IEventService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  IEventRepository eventRepository;
  IAtivoService ativoService;
  EventService({@required this.eventRepository, @required this.ativoService});

  @override
  Future<void> saveAplicacaoRendaVariavel(AplicacaoRendaVariavel aplicacaoEvent) {
    return eventRepository.save(aplicacaoEvent);
  }

  @override
  Future<List<AbstractEvent>> getAllEvents(String usuarioId, {bool onlyCache = true}) {
    return eventRepository.findAllEventos(usuarioId, onlyCache: onlyCache);
  }

  @override
  Future<void> delete(AbstractEvent event) {
    return eventRepository.delete(event);
  }

  @override
  Future<List<AbstractEvent>> getEventsByPeriodo(String usuarioId, DateTime inicio, DateTime fim,
      {bool onlyCache = true}) {
    return eventRepository.findEventosByPeriodo(usuarioId, inicio, fim, onlyCache: onlyCache);
  }
}
