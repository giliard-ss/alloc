import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/utils/connection_util.dart';
import 'package:alloc/app/shared/utils/exception_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IUsuarioRepository {
  Future<UsuarioModel> find(String email);
  Future<void> cadastrar(String nome, String email, Function(UsuarioModel) fnc);
}

class UsuarioRepository implements IUsuarioRepository {
  static final _table = "usuarios";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> cadastrar(
      String nome, String email, Function(UsuarioModel) fnc) async {
    await ConnectionUtil.checkConnection();
    try {
      DocumentReference ref = _db.collection(_table).doc();
      UsuarioModel usuario = UsuarioModel(ref.id, nome, email);

      return _db.runTransaction((tr) async {
        tr.set(ref, usuario.toMap());
        await fnc(usuario);
      });
    } catch (e) {
      ExceptionUtil.throwe(
          e, "Falha ao cadastrar novo usuário!" + e.toString());
    }
  }

  @override
  Future<UsuarioModel> find(String email) async {
    QuerySnapshot snapshot =
        await _db.collection(_table).where("email", isEqualTo: email).get();

    if (snapshot.docs.isEmpty) {
      return null;
    }
    return UsuarioModel.fromMap(snapshot.docs[0].data());
  }
}
