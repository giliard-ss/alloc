import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/repositories/usuario_repository.dart';
import 'package:alloc/app/shared/services/preference_service.dart';
import 'package:flutter/material.dart';

abstract class IUsuarioService {
  Future<UsuarioModel> getUsuario(String email);
  Future<void> cadastrar(String nome, String email);
}

class UsuarioService implements IUsuarioService {
  final UsuarioRepository usuarioRepository;
  final PreferenceService preferenceService;

  UsuarioService(
      {@required this.usuarioRepository, @required this.preferenceService});

  @override
  Future<UsuarioModel> getUsuario(String email) {
    return usuarioRepository.find(email);
  }

  @override
  Future<void> cadastrar(String nome, String email) async {
    await usuarioRepository.cadastrar(nome, email,
        (UsuarioModel usuario) async {
      await preferenceService.saveUsuario(usuario);
    });
  }
}
