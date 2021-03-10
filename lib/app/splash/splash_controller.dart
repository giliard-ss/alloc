import 'dart:convert';

import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/repositories/auth_repository.dart';
import 'package:alloc/app/shared/services/preference_service.dart';
import 'package:alloc/app/shared/utils/connection_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
part 'splash_controller.g.dart';

@Injectable()
class SplashController = _SplashControllerBase with _$SplashController;

abstract class _SplashControllerBase with Store {
  IAuthRepository _authRepository = Modular.get<AuthRepository>();
  IPreferenceService _preferenceService = Modular.get<PreferenceService>();

  Future<bool> verificaExisteLogin() async {
    //await _authRepository.googleLogout();
    User user = _authRepository.getUser();

    if (user != null) {
      UsuarioModel usuario =
          UsuarioModel(user.uid, user.displayName, user.email, user.photoURL);
      checkFoto(usuario);
      await AppCore.init(usuario);
    }
    return user != null;
  }

  Future<void> checkFoto(UsuarioModel usuario) async {
    UsuarioModel cached = await _preferenceService.getUsuario();

    if (await ConnectionUtil.isOffline()) {
      usuario.photoBase64 = cached.photoBase64;
      return;
    }

    if (cached == null || usuario.photoURL != cached.photoURL) {
      usuario.photoBase64 = await networkImageToBase64(usuario.photoURL);
      _preferenceService.saveUsuario(usuario);
    } else {
      usuario.photoBase64 = cached.photoBase64;
    }
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(imageUrl);
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }
}
