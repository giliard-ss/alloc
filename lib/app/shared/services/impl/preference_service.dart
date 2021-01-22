import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/ipreference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class PreferenceService implements IPreferenceService {
  static final String _keyUsuario = "_user";

  @override
  Future<void> saveUsuario(UsuarioModel usuario) async {
    await _setString(_keyUsuario, json.encode(usuario.toMap()));
  }

  @override
  Future<UsuarioModel> getUsuario() async {
    String result = await _getString(_keyUsuario);

    if (result == null) {
      return null;
    } else {
      return UsuarioModel.fromMap(json.decode(result));
    }
  }

  Future<SharedPreferences> _getInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> _setString(String key, String value) async {
    SharedPreferences sf = await _getInstance();
    sf.setString(key, value);
  }

  Future<String> _getString(String key) async {
    SharedPreferences sf = await _getInstance();
    if (!sf.containsKey(key)) {
      return null;
    } else {
      return sf.getString(key);
    }
  }
}
