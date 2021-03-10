import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

abstract class IPreferenceService {
  Future<void> saveUsuario(UsuarioModel usuario);
  Future<UsuarioModel> getUsuario();
  Future<void> saveLastUpdateCotacoes(DateTime date);
  Future<DateTime> getLastUpdateCotacoes();
}

class PreferenceService implements IPreferenceService {
  static final String _keyUsuario = "_user";
  static final String _keyLastUpdateCotacoes = "_lastUpdateCotacoes";

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

  @override
  Future<void> saveLastUpdateCotacoes(DateTime date) {
    return _setString(
        _keyLastUpdateCotacoes, date.millisecondsSinceEpoch.toString());
  }

  @override
  Future<DateTime> getLastUpdateCotacoes() async {
    SharedPreferences sf = await _getInstance();
    if (!sf.containsKey(_keyLastUpdateCotacoes)) {
      return null;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(
          int.parse(sf.getString(_keyLastUpdateCotacoes)));
    }
  }
}
