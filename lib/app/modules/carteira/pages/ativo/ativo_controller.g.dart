// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ativo_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $AtivoController = BindInject(
  (i) => AtivoController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AtivoController on _AtivoControllerBase, Store {
  final _$errorAtom = Atom(name: '_AtivoControllerBase.error');

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

  final _$comprarAsyncAction = AsyncAction('_AtivoControllerBase.comprar');

  @override
  Future<bool> comprar() {
    return _$comprarAsyncAction.run(() => super.comprar());
  }

  final _$_AtivoControllerBaseActionController =
      ActionController(name: '_AtivoControllerBase');

  @override
  Future<bool> vender() {
    final _$actionInfo = _$_AtivoControllerBaseActionController.startAction(
        name: '_AtivoControllerBase.vender');
    try {
      return super.vender();
    } finally {
      _$_AtivoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
error: ${error}
    ''';
  }
}
