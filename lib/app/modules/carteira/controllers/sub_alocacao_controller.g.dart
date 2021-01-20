// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_alocacao_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $SubAlocacaoController = BindInject(
  (i) => SubAlocacaoController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SubAlocacaoController on _SubAlocacaoControllerBase, Store {
  final _$alocacoesAtom = Atom(name: '_SubAlocacaoControllerBase.alocacoes');

  @override
  List<AlocacaoDTO> get alocacoes {
    _$alocacoesAtom.reportRead();
    return super.alocacoes;
  }

  @override
  set alocacoes(List<AlocacaoDTO> value) {
    _$alocacoesAtom.reportWrite(value, super.alocacoes, () {
      super.alocacoes = value;
    });
  }

  @override
  String toString() {
    return '''
alocacoes: ${alocacoes}
    ''';
  }
}
