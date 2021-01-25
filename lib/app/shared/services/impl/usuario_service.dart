import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/repositories/impl/usuario_repository.dart';
import 'package:alloc/app/shared/services/impl/preference_service.dart';
import 'package:alloc/app/shared/services/iusuario_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
