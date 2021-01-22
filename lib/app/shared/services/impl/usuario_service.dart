import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/repositories/impl/usuario_repository.dart';
import 'package:alloc/app/shared/services/iusuario_service.dart';
import 'package:flutter/material.dart';

class UsuarioService implements IUsuarioService {
  final UsuarioRepository usuarioRepository;

  UsuarioService({@required this.usuarioRepository});

  @override
  Future<UsuarioModel> getUsuario(String email) {
    return usuarioRepository.find(email);
  }
}
