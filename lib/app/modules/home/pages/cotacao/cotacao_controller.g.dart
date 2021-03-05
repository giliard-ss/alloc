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
  final _$ativosAtom = Atom(name: '_CotacaoControllerBase.ativos');

  @override
  List<AtivoDTO> get ativos {
    _$ativosAtom.reportRead();
    return super.ativos;
  }

  @override
  set ativos(List<AtivoDTO> value) {
    _$ativosAtom.reportWrite(value, super.ativos, () {
      super.ativos = value;
    });
  }

  @override
  String toString() {
    return '''
ativos: ${ativos}
    ''';
  }
}
