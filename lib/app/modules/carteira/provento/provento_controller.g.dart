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
  final _$valueAtom = Atom(name: '_ProventoControllerBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$_ProventoControllerBaseActionController =
      ActionController(name: '_ProventoControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_ProventoControllerBaseActionController.startAction(
        name: '_ProventoControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_ProventoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
