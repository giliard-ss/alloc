// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuracao_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $ConfiguracaoController = BindInject(
  (i) => ConfiguracaoController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConfiguracaoController on _ConfiguracaoControllerBase, Store {
  final _$alocacoesAtom = Atom(name: '_ConfiguracaoControllerBase.alocacoes');

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

  final _$ativosAtom = Atom(name: '_ConfiguracaoControllerBase.ativos');

  @override
  List<AtivoModel> get ativos {
    _$ativosAtom.reportRead();
    return super.ativos;
  }

  @override
  set ativos(List<AtivoModel> value) {
    _$ativosAtom.reportWrite(value, super.ativos, () {
      super.ativos = value;
    });
  }

  @override
  String toString() {
    return '''
alocacoes: ${alocacoes},
ativos: ${ativos}
    ''';
  }
}
