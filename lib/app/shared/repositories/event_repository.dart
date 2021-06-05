import 'package:alloc/app/shared/config/cf_settings.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/evento_aplicacao.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/models/evento_deposito.dart';
import 'package:alloc/app/shared/models/evento_provento.dart';
import 'package:alloc/app/shared/models/evento_saque.dart';
import 'package:alloc/app/shared/models/evento_venda.dart';
import 'package:alloc/app/shared/models/evento_venda_renda_variavel.dart';
import 'package:alloc/app/shared/utils/connection_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract class IEventRepository {
  Future<List<AbstractEvent>> findAllEventos(String usuarioId, {bool onlyCache});
  Future<List<AbstractEvent>> findEventosByCarteiraAndPeriodo(
      String usuarioId, String carteiraId, DateTime inicio, DateTime fim,
      {bool onlyCache});
  Future<List<AbstractEvent>> findEventosByCarteiraAndPeriodoAndTipo(
      String usuarioId, String carteiraId, DateTime inicio, DateTime fim, TipoEvento tipo,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByTipoAndCarteira(
      String usuarioId, String tipoEvento, String carteiraId,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByCarteiraAndAlocacaoAndPapel(
      String usuarioId, String carteiraId, String idAlocacao, String papel,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByCarteiraAndPapel(
      String usuarioId, String carteiraId, String papel,
      {bool onlyCache});
  Future<List<AbstractEvent>> getEventsByTipo(String usuarioId, String tipoEvento,
      {bool onlyCache});
  Future<AbstractEvent> findEventById(String id, {bool onlyCache});
  String saveTransaction(Transaction tr, AbstractEvent event);
  Future<void> save(AbstractEvent event);
  Future<void> delete(AbstractEvent event);
  Future<void> deleteTransactionByCarteira(Transaction transaction, String carteiraId);
  void deleteTransaction(Transaction transaction, AbstractEvent event);
}

class EventRepository implements IEventRepository {
  static final _table = "eventos";
  FirebaseFirestore _db = FirebaseFirestore.instance;
  var uuid = Uuid();

  @override
  Future<List<AbstractEvent>> findAllEventos(String usuarioId, {bool onlyCache = true}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("usuarioId", isEqualTo: usuarioId)
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));
    return List.generate(snapshot.docs.length, (i) {
      return mapToEvent(snapshot.docs[i].data());
    });
  }

  @override
  Future<List<AbstractEvent>> getEventsByTipoAndCarteira(
      String usuarioId, String tipoEvento, String carteiraId,
      {bool onlyCache = true}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("usuarioId", isEqualTo: usuarioId)
        .where("tipoEvento", isEqualTo: tipoEvento)
        .where("carteiraId", isEqualTo: carteiraId)
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));
    return List.generate(snapshot.docs.length, (i) {
      return mapToEvent(snapshot.docs[i].data());
    });
  }

  @override
  Future<AbstractEvent> findEventById(String id, {bool onlyCache = true}) async {
    DocumentSnapshot snapshot = await _db.collection(_table).doc(id).get();

    if (snapshot.exists) return mapToEvent(snapshot.data());
    throw ApplicationException("Evento não encontrado! $id");
  }

  AbstractEvent mapToEvent(Map map) {
    if (map['tipoEvento'] == EventoDeposito.name) {
      return EventoDeposito.fromMap(map);
    }

    if (map['tipoEvento'] == EventoSaque.name) {
      return EventoSaque.fromMap(map);
    }

    if (map['tipoEvento'] == EventoProvento.name) {
      return EventoProvento.fromMap(map);
    }

    if (map['tipoEvento'] == EventoVenda.name && TipoAtivo(map["tipoAtivo"]).isRendaVariavel()) {
      return VendaRendaVariavelEvent.fromMap(map);
    }

    if (map['tipoEvento'] == EventoAplicacao.name &&
        TipoAtivo(map["tipoAtivo"]).isRendaVariavel()) {
      return AplicacaoRendaVariavel.fromMap(map);
    }
    throw ApplicationException("Evento não mapeado.");
  }

  @override
  String saveTransaction(Transaction tr, AbstractEvent novoEvento) {
    try {
      DocumentReference ref = _db.collection(_table).doc();
      novoEvento.setId(ref.id);
      tr.set(ref, novoEvento.toMap());
      return ref.id;
    } catch (e) {
      throw ApplicationException('Falha ao salvar evento' + e.toString());
    }
  }

  @override
  Future<void> save(AbstractEvent event) async {
    await ConnectionUtil.checkConnection();
    try {
      DocumentReference ref;
      if (StringUtil.isEmpty(event.getId())) {
        ref = _db.collection(_table).doc();
        event.setId(ref.id);
      } else {
        ref = _db.collection(_table).doc(event.getId());
      }

      await ref.set(event.toMap());
    } catch (e) {
      throw ApplicationException('Falha ao salvar evento' + e.toString());
    }
  }

  @override
  Future<void> delete(AbstractEvent event) async {
    await ConnectionUtil.checkConnection();
    try {
      DocumentReference ref = _db.collection(_table).doc(event.getId());
      await ref.delete();
    } catch (e) {
      throw ApplicationException('Falha ao deletar evento' + e.toString());
    }
  }

  @override
  Future<void> deleteTransactionByCarteira(Transaction transaction, String carteiraId) async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection(_table).where("carteiraId", isEqualTo: carteiraId).get();

      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
        transaction.delete(doc.reference);
      });
    } catch (e) {
      throw ApplicationException('Falha ao deletar evento' + e.toString());
    }
  }

  @override
  Future<List<AbstractEvent>> findEventosByCarteiraAndPeriodo(
      String usuarioId, String carteiraId, DateTime inicio, DateTime fim,
      {bool onlyCache = true}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("usuarioId", isEqualTo: usuarioId)
        .where("carteiraId", isEqualTo: carteiraId)
        .where("data", isGreaterThanOrEqualTo: inicio.millisecondsSinceEpoch)
        .where("data", isLessThanOrEqualTo: fim.millisecondsSinceEpoch)
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));
    return List.generate(snapshot.docs.length, (i) {
      return mapToEvent(snapshot.docs[i].data());
    });
  }

  @override
  Future<List<AbstractEvent>> getEventsByTipo(String usuarioId, String tipoEvento,
      {bool onlyCache = true}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("usuarioId", isEqualTo: usuarioId)
        .where("tipoEvento", isEqualTo: tipoEvento)
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));
    return List.generate(snapshot.docs.length, (i) {
      return mapToEvent(snapshot.docs[i].data());
    });
  }

  @override
  Future<List<AbstractEvent>> getEventsByCarteiraAndAlocacaoAndPapel(
      String usuarioId, String carteiraId, String alocacaoId, String papel,
      {bool onlyCache = true}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("usuarioId", isEqualTo: usuarioId)
        .where("carteiraId", isEqualTo: carteiraId)
        .where("superiores", arrayContains: alocacaoId)
        .where("papel", isEqualTo: papel)
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));
    return List.generate(snapshot.docs.length, (i) {
      return mapToEvent(snapshot.docs[i].data());
    });
  }

  @override
  Future<List<AbstractEvent>> getEventsByCarteiraAndPapel(
      String usuarioId, String carteiraId, String papel,
      {bool onlyCache}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("usuarioId", isEqualTo: usuarioId)
        .where("carteiraId", isEqualTo: carteiraId)
        .where("papel", isEqualTo: papel)
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));
    return List.generate(snapshot.docs.length, (i) {
      return mapToEvent(snapshot.docs[i].data());
    });
  }

  @override
  void deleteTransaction(Transaction transaction, AbstractEvent event) {
    try {
      DocumentReference reference = _db.collection(_table).doc(event.getId());
      transaction.delete(reference);
    } catch (e) {
      throw ApplicationException('Falha ao deletar evento' + e.toString());
    }
  }

  @override
  Future<List<AbstractEvent>> findEventosByCarteiraAndPeriodoAndTipo(
      String usuarioId, String carteiraId, DateTime inicio, DateTime fim, TipoEvento tipo,
      {bool onlyCache = true}) async {
    QuerySnapshot snapshot = await _db
        .collection(_table)
        .where("usuarioId", isEqualTo: usuarioId)
        .where("carteiraId", isEqualTo: carteiraId)
        .where("data", isGreaterThanOrEqualTo: inicio.millisecondsSinceEpoch)
        .where("data", isLessThanOrEqualTo: fim.millisecondsSinceEpoch)
        .where("tipoEvento", isEqualTo: tipo.toString())
        .get(await CfSettrings.getOptions(onlyCache: onlyCache));
    return List.generate(snapshot.docs.length, (i) {
      return mapToEvent(snapshot.docs[i].data());
    });
  }
}
