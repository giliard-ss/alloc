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

  final _$percentualRestanteAtom =
      Atom(name: '_ConfiguracaoControllerBase.percentualRestante');

  @override
  double get percentualRestante {
    _$percentualRestanteAtom.reportRead();
    return super.percentualRestante;
  }

  @override
  set percentualRestante(double value) {
    _$percentualRestanteAtom.reportWrite(value, super.percentualRestante, () {
      super.percentualRestante = value;
    });
  }

  final _$autoAlocacaoAtom =
      Atom(name: '_ConfiguracaoControllerBase.autoAlocacao');

  @override
  bool get autoAlocacao {
    _$autoAlocacaoAtom.reportRead();
    return super.autoAlocacao;
  }

  @override
  set autoAlocacao(bool value) {
    _$autoAlocacaoAtom.reportWrite(value, super.autoAlocacao, () {
      super.autoAlocacao = value;
    });
  }

  final _$_ConfiguracaoControllerBaseActionController =
      ActionController(name: '_ConfiguracaoControllerBase');

  @override
  void changeAutoAlocacao(bool value) {
    final _$actionInfo = _$_ConfiguracaoControllerBaseActionController
        .startAction(name: '_ConfiguracaoControllerBase.changeAutoAlocacao');
    try {
      return super.changeAutoAlocacao(value);
    } finally {
      _$_ConfiguracaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkAlocacoesValues() {
    final _$actionInfo = _$_ConfiguracaoControllerBaseActionController
        .startAction(name: '_ConfiguracaoControllerBase.checkAlocacoesValues');
    try {
      return super.checkAlocacoesValues();
    } finally {
      _$_ConfiguracaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
alocacoes: ${alocacoes},
percentualRestante: ${percentualRestante},
autoAlocacao: ${autoAlocacao}
    ''';
  }
}
