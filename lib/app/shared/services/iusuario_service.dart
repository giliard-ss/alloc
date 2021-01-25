import 'package:alloc/app/shared/models/usuario_model.dart';

abstract class IUsuarioService {
  Future<UsuarioModel> getUsuario(String email);
  Future<void> cadastrar(String nome, String email);
}
