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
  Computed<bool> _$papelValidoComputed;

  @override
  bool get papelValido =>
      (_$papelValidoComputed ??= Computed<bool>(() => super.papelValido,
              name: '_AtivoControllerBase.papelValido'))
          .value;

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

  final _$papelAtom = Atom(name: '_AtivoControllerBase.papel');

  @override
  String get papel {
    _$papelAtom.reportRead();
    return super.papel;
  }

  @override
  set papel(String value) {
    _$papelAtom.reportWrite(value, super.papel, () {
      super.papel = value;
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

  final _$salvarAsyncAction = AsyncAction('_AtivoControllerBase.salvar');

  @override
  Future<bool> salvar() {
    return _$salvarAsyncAction.run(() => super.salvar());
  }

  final _$_AtivoControllerBaseActionController =
      ActionController(name: '_AtivoControllerBase');

  @override
  void setPapel(String papel) {
    final _$actionInfo = _$_AtivoControllerBaseActionController.startAction(
        name: '_AtivoControllerBase.setPapel');
    try {
      return super.setPapel(papel);
    } finally {
      _$_AtivoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
error: ${error},
papel: ${papel},
papelValido: ${papelValido}
    ''';
  }
}
