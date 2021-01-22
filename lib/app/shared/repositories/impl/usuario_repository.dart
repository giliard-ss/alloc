import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/repositories/iusuario_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioRepository implements IUsuarioRepository {
  static final _table = "usuarios";
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<UsuarioModel> cadastrar(String nome, String email) {
    // TODO: implement cadastrar
    throw UnimplementedError();
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
