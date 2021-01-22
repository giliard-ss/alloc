import 'package:alloc/app/shared/models/usuario_model.dart';

abstract class IPreferenceService {
  Future<void> saveUsuario(UsuarioModel usuario);
  Future<UsuarioModel> getUsuario();
}
