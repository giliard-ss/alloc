// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cotacao_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $CotacaoController = BindInject(
  (i) => CotacaoController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CotacaoController on _CotacaoControllerBase, Store {
  final _$acoesAtom = Atom(name: '_CotacaoControllerBase.acoes');

  @override
  List<AtivoDTO> get acoes {
    _$acoesAtom.reportRead();
    return super.acoes;
  }

  @override
  set acoes(List<AtivoDTO> value) {
    _$acoesAtom.reportWrite(value, super.acoes, () {
      super.acoes = value;
    });
  }

  @override
  String toString() {
    return '''
acoes: ${acoes}
    ''';
  }
}
