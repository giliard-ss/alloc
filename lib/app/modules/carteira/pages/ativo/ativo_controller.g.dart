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

  final _$tipoAtom = Atom(name: '_AtivoControllerBase.tipo');

  @override
  String get tipo {
    _$tipoAtom.reportRead();
    return super.tipo;
  }

  @override
  set tipo(String value) {
    _$tipoAtom.reportWrite(value, super.tipo, () {
      super.tipo = value;
    });
  }

  final _$comprarAsyncAction = AsyncAction('_AtivoControllerBase.comprar');

  @override
  Future<bool> comprar() {
    return _$comprarAsyncAction.run(() => super.comprar());
  }

  final _$venderAsyncAction = AsyncAction('_AtivoControllerBase.vender');

  @override
  Future<bool> vender() {
    return _$venderAsyncAction.run(() => super.vender());
  }

  final _$_AtivoControllerBaseActionController =
      ActionController(name: '_AtivoControllerBase');

  @override
  void changeTipo(String value) {
    final _$actionInfo = _$_AtivoControllerBaseActionController.startAction(
        name: '_AtivoControllerBase.changeTipo');
    try {
      return super.changeTipo(value);
    } finally {
      _$_AtivoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
error: ${error},
tipo: ${tipo}
    ''';
  }
}
