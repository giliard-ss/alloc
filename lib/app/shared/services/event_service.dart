import 'package:alloc/app/shared/adapters/firebase_adapter.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/repositories/event_repository.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IEventService {
  Future<void> save(AbstractEvent event);
  Future<List<AbstractEvent>> getAllEvents(String usuarioId, {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByTipoAndCarteira(
      String usuarioId, String tipoEvento, String carteiraId,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByCarteiraAndAlocacaoAndPapel(
      String usuarioId, String carteiraId, String alocacaoId, String papelId,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByCarteiraAndPapel(
      String usuarioId, String carteiraId, String papelId,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByTipo(String usuarioId, String tipoEvento,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByCarteiraAndPeriodo(
      String usuarioId, String carteiraId, DateTime inicio, DateTime fim,
      {bool onlyCache});
  Future<void> delete(AbstractEvent event);
  Future<void> deleteAll(List<AbstractEvent> events);

  Future<AbstractEvent> getEventById(String id);
}

class EventService implements IEventService {
  IEventRepository eventRepository;
  IAtivoService ativoService;
  FirebaseAdapter firebaseAdapter = new FirebaseAdapter();
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

  @override
  Future<List<AbstractEvent>> getEventsByCarteiraAndAlocacaoAndPapel(
      String usuarioId, String carteiraId, String alocacaoId, String papelId,
      {bool onlyCache = true}) {
    return eventRepository.getEventsByCarteiraAndAlocacaoAndPapel(
        usuarioId, carteiraId, alocacaoId, papelId,
        onlyCache: onlyCache);
  }

  @override
  Future<List<AbstractEvent>> getEventsByCarteiraAndPapel(
      String usuarioId, String carteiraId, String papelId,
      {bool onlyCache = true}) {
    return eventRepository.getEventsByCarteiraAndPapel(usuarioId, carteiraId, papelId,
        onlyCache: onlyCache);
  }

  @override
  Future<void> deleteAll(List<AbstractEvent> events) async {
    await firebaseAdapter.runTransaction((Transaction transaction) async {
      for (AbstractEvent event in events) {
        eventRepository.deleteTransaction(transaction, event);
      }
    });

    for (AbstractEvent event in events) {
      await _atualizarEventoDeletadoNoCache(event);
    }
  }

  Future<void> _atualizarEventoDeletadoNoCache(AbstractEvent event) async {
    if (await _existsEvent(event))
      throw new ApplicationException("Falha ao deletar evento do tipo " + event.getTipoEvento());
  }

  Future<bool> _existsEvent(AbstractEvent event) async {
    try {
      await eventRepository.findEventById(event.getId());
      return true;
    } on ApplicationException catch (e) {
      return false;
    }
  }

  @override
  Future<AbstractEvent> getEventById(String id) {
    return eventRepository.findEventById(id);
  }
}
