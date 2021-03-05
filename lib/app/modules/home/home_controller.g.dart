// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $HomeController = BindInject(
  (i) => HomeController(),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  Computed<int> _$maiorQuantItemsExistenteListasComputed;

  @override
  int get maiorQuantItemsExistenteListas =>
      (_$maiorQuantItemsExistenteListasComputed ??= Computed<int>(
              () => super.maiorQuantItemsExistenteListas,
              name: '_HomeControllerBase.maiorQuantItemsExistenteListas'))
          .value;

  final _$errorAtom = Atom(name: '_HomeControllerBase.error');

  @override
  String get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$carteirasAtom = Atom(name: '_HomeControllerBase.carteiras');

  @override
  List<CarteiraDTO> get carteiras {
    _$carteirasAtom.reportRead();
    return super.carteiras;
  }

  @override
  set carteiras(List<CarteiraDTO> value) {
    _$carteirasAtom.reportWrite(value, super.carteiras, () {
      super.carteiras = value;
    });
  }

  final _$acoesAtom = Atom(name: '_HomeControllerBase.acoes');

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

  final _$fiisAtom = Atom(name: '_HomeControllerBase.fiis');

  @override
  List<AtivoDTO> get fiis {
    _$fiisAtom.reportRead();
    return super.fiis;
  }

  @override
  set fiis(List<AtivoDTO> value) {
    _$fiisAtom.reportWrite(value, super.fiis, () {
      super.fiis = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_HomeControllerBase.init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$salvarNovaCarteiraAsyncAction =
      AsyncAction('_HomeControllerBase.salvarNovaCarteira');

  @override
  Future<bool> salvarNovaCarteira() {
    return _$salvarNovaCarteiraAsyncAction
        .run(() => super.salvarNovaCarteira());
  }

  final _$refreshAsyncAction = AsyncAction('_HomeControllerBase.refresh');

  @override
  Future<dynamic> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  @override
  String toString() {
    return '''
error: ${error},
carteiras: ${carteiras},
acoes: ${acoes},
fiis: ${fiis},
maiorQuantItemsExistenteListas: ${maiorQuantItemsExistenteListas}
    ''';
  }
}
