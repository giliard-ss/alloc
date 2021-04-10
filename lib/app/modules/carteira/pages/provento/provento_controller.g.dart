// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provento_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $ProventoController = BindInject(
  (i) => ProventoController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProventoController on _ProventoControllerBase, Store {
  Computed<bool> _$papelValidoComputed;

  @override
  bool get papelValido =>
      (_$papelValidoComputed ??= Computed<bool>(() => super.papelValido,
              name: '_ProventoControllerBase.papelValido'))
          .value;

  final _$errorAtom = Atom(name: '_ProventoControllerBase.error');

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

  final _$papelAtom = Atom(name: '_ProventoControllerBase.papel');

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

  final _$salvarAsyncAction = AsyncAction('_ProventoControllerBase.salvar');

  @override
  Future<bool> salvar() {
    return _$salvarAsyncAction.run(() => super.salvar());
  }

  final _$_ProventoControllerBaseActionController =
      ActionController(name: '_ProventoControllerBase');

  @override
  void setPapel(String papel) {
    final _$actionInfo = _$_ProventoControllerBaseActionController.startAction(
        name: '_ProventoControllerBase.setPapel');
    try {
      return super.setPapel(papel);
    } finally {
      _$_ProventoControllerBaseActionController.endAction(_$actionInfo);
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
