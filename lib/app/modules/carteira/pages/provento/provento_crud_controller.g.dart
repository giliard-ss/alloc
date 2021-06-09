// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provento_crud_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $ProventoCrudController = BindInject(
  (i) => ProventoCrudController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProventoCrudController on _ProventoCrudControllerBase, Store {
  Computed<bool> _$papelValidoComputed;

  @override
  bool get papelValido =>
      (_$papelValidoComputed ??= Computed<bool>(() => super.papelValido,
              name: '_ProventoCrudControllerBase.papelValido'))
          .value;

  final _$errorAtom = Atom(name: '_ProventoCrudControllerBase.error');

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

  final _$papelAtom = Atom(name: '_ProventoCrudControllerBase.papel');

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

  final _$salvarAsyncAction = AsyncAction('_ProventoCrudControllerBase.salvar');

  @override
  Future<bool> salvar() {
    return _$salvarAsyncAction.run(() => super.salvar());
  }

  final _$_ProventoCrudControllerBaseActionController =
      ActionController(name: '_ProventoCrudControllerBase');

  @override
  void setPapel(String papel) {
    final _$actionInfo = _$_ProventoCrudControllerBaseActionController
        .startAction(name: '_ProventoCrudControllerBase.setPapel');
    try {
      return super.setPapel(papel);
    } finally {
      _$_ProventoCrudControllerBaseActionController.endAction(_$actionInfo);
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
