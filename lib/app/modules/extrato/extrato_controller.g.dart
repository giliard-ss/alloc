// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extrato_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $ExtratoController = BindInject(
  (i) => ExtratoController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ExtratoController on _ExtratoControllerBase, Store {
  final _$eventsAtom = Atom(name: '_ExtratoControllerBase.events');

  @override
  List<AbstractEvent> get events {
    _$eventsAtom.reportRead();
    return super.events;
  }

  @override
  set events(List<AbstractEvent> value) {
    _$eventsAtom.reportWrite(value, super.events, () {
      super.events = value;
    });
  }

  @override
  String toString() {
    return '''
events: ${events}
    ''';
  }
}
