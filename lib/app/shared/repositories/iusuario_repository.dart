import 'package:alloc/app/shared/models/usuario_model.dart';

abstract class IUsuarioRepository {
  Future<UsuarioModel> find(String email);

  Future<void> cadastrar(String nome, String email, Function(UsuarioModel) fnc);
}
