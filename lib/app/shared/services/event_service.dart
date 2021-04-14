import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/repositories/event_repository.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:flutter/material.dart';

abstract class IEventService {
  Future<void> save(AbstractEvent event);
  Future<List<AbstractEvent>> getAllEvents(String usuarioId, {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByTipoAndCarteira(
      String usuarioId, String tipoEvento, String carteiraId,
      {bool onlyCache});

  Future<List<AbstractEvent>> getEventsByTipo(String usuarioId, String tipoEvento,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByCarteiraAndPeriodo(
      String usuarioId, String carteiraId, DateTime inicio, DateTime fim,
      {bool onlyCache});
  Future<void> delete(AbstractEvent event);
}

class EventService implements IEventService {
  IEventRepository eventRepository;
  IAtivoService ativoService;
  EventService({@required this.eventRepository, @required this.ativoService});

  @override
  Future<void> save(AbstractEvent event) {
    return eventRepository.save(event);
  }

  @override
  Future<List<AbstractEvent>> getAllEvents(String usuarioId, {bool onlyCache = true}) {
    return eventRepository.findAllEventos(usuarioId, onlyCache: onlyCache);
  }

  @override
  Future<List<AbstractEvent>> getEventsByTipoAndCarteira(
      String usuarioId, String tipoEvento, String carteiraId,
      {bool onlyCache = true}) {
    return eventRepository.getEventsByTipoAndCarteira(usuarioId, tipoEvento, carteiraId,
        onlyCache: onlyCache);
  }

  @override
  Future<void> delete(AbstractEvent event) {
    return eventRepository.delete(event);
  }

  @override
  Future<List<AbstractEvent>> getEventsByCarteiraAndPeriodo(
      String usuarioId, String carteiraId, DateTime inicio, DateTime fim,
      {bool onlyCache = true}) {
    return eventRepository.findEventosByCarteiraAndPeriodo(usuarioId, carteiraId, inicio, fim,
        onlyCache: onlyCache);
  }

  @override
  Future<List<AbstractEvent>> getEventsByTipo(String usuarioId, String tipoEvento,
      {bool onlyCache = true}) {
    return eventRepository.getEventsByTipo(usuarioId, tipoEvento, onlyCache: onlyCache);
  }
}
