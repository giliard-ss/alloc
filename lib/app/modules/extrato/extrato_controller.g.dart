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

  final _$_mesAnoAtom = Atom(name: '_ExtratoControllerBase._mesAno');

  @override
  DateTime get _mesAno {
    _$_mesAnoAtom.reportRead();
    return super._mesAno;
  }

  @override
  set _mesAno(DateTime value) {
    _$_mesAnoAtom.reportWrite(value, super._mesAno, () {
      super._mesAno = value;
    });
  }

  final _$resumoAtom = Atom(name: '_ExtratoControllerBase.resumo');

  @override
  List<ExtratoResumoDTO> get resumo {
    _$resumoAtom.reportRead();
    return super.resumo;
  }

  @override
  set resumo(List<ExtratoResumoDTO> value) {
    _$resumoAtom.reportWrite(value, super.resumo, () {
      super.resumo = value;
    });
  }

  final _$selectMesAnoAsyncAction =
      AsyncAction('_ExtratoControllerBase.selectMesAno');

  @override
  Future<void> selectMesAno(DateTime value) {
    return _$selectMesAnoAsyncAction.run(() => super.selectMesAno(value));
  }

  final _$selectTipoEventoAsyncAction =
      AsyncAction('_ExtratoControllerBase.selectTipoEvento');

  @override
  Future<void> selectTipoEvento(TipoEvento tipoEvento) {
    return _$selectTipoEventoAsyncAction
        .run(() => super.selectTipoEvento(tipoEvento));
  }

  @override
  String toString() {
    return '''
events: ${events},
resumo: ${resumo}
    ''';
  }
}
