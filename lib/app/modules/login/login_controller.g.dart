// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $LoginController = BindInject(
  (i) => LoginController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginController on _LoginControllerBase, Store {
  final _$emailAtom = Atom(name: '_LoginControllerBase.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$errorAtom = Atom(name: '_LoginControllerBase.error');

  @override
  String get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$aguardaCodigoAtom = Atom(name: '_LoginControllerBase.aguardaCodigo');

  @override
  bool get aguardaCodigo {
    _$aguardaCodigoAtom.reportRead();
    return super.aguardaCodigo;
  }

  @override
  set aguardaCodigo(bool value) {
    _$aguardaCodigoAtom.reportWrite(value, super.aguardaCodigo, () {
      super.aguardaCodigo = value;
    });
  }

  final _$entrarAsyncAction = AsyncAction('_LoginControllerBase.entrar');

  @override
  Future<bool> entrar() {
    return _$entrarAsyncAction.run(() => super.entrar());
  }

  final _$_LoginControllerBaseActionController =
      ActionController(name: '_LoginControllerBase');

  @override
  dynamic changeEmail(dynamic text) {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.changeEmail');
    try {
      return super.changeEmail(text);
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic cancelar() {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.cancelar');
    try {
      return super.cancelar();
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
error: ${error},
aguardaCodigo: ${aguardaCodigo}
    ''';
  }
}
