// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposito_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $DepositoController = BindInject(
  (i) => DepositoController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DepositoController on _DepositoControllerBase, Store {
  final _$valueAtom = Atom(name: '_DepositoControllerBase.value');

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

  final _$_DepositoControllerBaseActionController =
      ActionController(name: '_DepositoControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_DepositoControllerBaseActionController.startAction(
        name: '_DepositoControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_DepositoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
