import 'package:alloc/app/shared/config/cf_settings.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/evento_aplicacao.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/utils/connection_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract class IEventRepository {
  Future<List<AbstractEvent>> findAllEventos(String usuarioId, {bool onlyCache});
  Future<AbstractEvent> findEventById(String id, {bool onlyCache});
  Future<String> saveTransaction(Transaction tr, AbstractEvent event);
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
  Future<AbstractEvent> findEventById(String id, {bool onlyCache = true}) async {
    DocumentSnapshot snapshot = await _db.collection(_table).doc(id).get();

    if (snapshot.exists) return mapToEvent(snapshot.data());
    throw ApplicationException("Evento não encontrado! $id");
  }

  AbstractEvent mapToEvent(Map map) {
    if (map['tipoEvento'] == EventoAplicacao.name &&
        TipoAtivo(map["tipoAtivo"]).isRendaVariavel()) {
      return AplicacaoRendaVariavel.fromMap(map);
    }
    throw ApplicationException("Evento não mapeado.");
  }

  @override
  Future<String> saveTransaction(Transaction tr, AbstractEvent novoEvento) async {
    await ConnectionUtil.checkConnection();
    try {
      DocumentReference ref = _db.collection(_table).doc();
      novoEvento.setId(ref.id);
      tr.set(ref, novoEvento.toMap());
      return ref.id;
    } catch (e) {
      throw ApplicationException('Falha ao salvar evento' + e.toString());
    }
  }
}
