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
  final _$novaAlocacaoErrorAtom =
      Atom(name: '_SubAlocacaoControllerBase.novaAlocacaoError');

  @override
  String get novaAlocacaoError {
    _$novaAlocacaoErrorAtom.reportRead();
    return super.novaAlocacaoError;
  }

  @override
  set novaAlocacaoError(String value) {
    _$novaAlocacaoErrorAtom.reportWrite(value, super.novaAlocacaoError, () {
      super.novaAlocacaoError = value;
    });
  }

  final _$salvarNovaAlocacaoAsyncAction =
      AsyncAction('_SubAlocacaoControllerBase.salvarNovaAlocacao');

  @override
  Future<bool> salvarNovaAlocacao(List<AlocacaoDTO> alocacoes) {
    return _$salvarNovaAlocacaoAsyncAction
        .run(() => super.salvarNovaAlocacao(alocacoes));
  }

  @override
  String toString() {
    return '''
novaAlocacaoError: ${novaAlocacaoError}
    ''';
  }
}
