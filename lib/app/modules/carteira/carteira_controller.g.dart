// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carteira_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $CarteiraController = BindInject(
  (i) => CarteiraController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CarteiraController on _CarteiraControllerBase, Store {
  final _$alocacoesAtom = Atom(name: '_CarteiraControllerBase.alocacoes');

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

  final _$ativosAtom = Atom(name: '_CarteiraControllerBase.ativos');

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

  final _$_carteiraAtom = Atom(name: '_CarteiraControllerBase._carteira');

  @override
  CarteiraDTO get _carteira {
    _$_carteiraAtom.reportRead();
    return super._carteira;
  }

  @override
  set _carteira(CarteiraDTO value) {
    _$_carteiraAtom.reportWrite(value, super._carteira, () {
      super._carteira = value;
    });
  }

  final _$errorDialogAtom = Atom(name: '_CarteiraControllerBase.errorDialog');

  @override
  String get errorDialog {
    _$errorDialogAtom.reportRead();
    return super.errorDialog;
  }

  @override
  set errorDialog(String value) {
    _$errorDialogAtom.reportWrite(value, super.errorDialog, () {
      super.errorDialog = value;
    });
  }

  @override
  String toString() {
    return '''
alocacoes: ${alocacoes},
ativos: ${ativos},
errorDialog: ${errorDialog}
    ''';
  }
}
