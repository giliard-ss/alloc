import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/repositories/iusuario_repository.dart';
import 'package:alloc/app/shared/utils/exception_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioRepository implements IUsuarioRepository {
  static final _table = "usuarios";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> cadastrar(
      String nome, String email, Function(UsuarioModel) fnc) async {
    DocumentReference rf = _db.collection(_table).doc();
    UsuarioModel usuario = UsuarioModel(rf.id, nome, email);

    await _db.runTransaction((transaction) async {
      transaction.set(rf, usuario.toMap());
      await fnc(usuario);
    }).catchError((e) {
      ExceptionUtil.throwe(
          e, "Falha ao cadastrar novo usuário!" + e.toString());
    }).whenComplete(() {
      return usuario;
    });
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
