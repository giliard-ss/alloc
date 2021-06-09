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
  final _$proventosAtom = Atom(name: '_ProventoControllerBase.proventos');

  @override
  List<ProventoDTO> get proventos {
    _$proventosAtom.reportRead();
    return super.proventos;
  }

  @override
  set proventos(List<ProventoDTO> value) {
    _$proventosAtom.reportWrite(value, super.proventos, () {
      super.proventos = value;
    });
  }

  final _$recebiAsyncAction = AsyncAction('_ProventoControllerBase.recebi');

  @override
  Future<String> recebi(ProventoDTO provento) {
    return _$recebiAsyncAction.run(() => super.recebi(provento));
  }

  @override
  String toString() {
    return '''
proventos: ${proventos}
    ''';
  }
}
