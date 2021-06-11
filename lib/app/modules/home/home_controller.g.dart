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
  Computed<double> _$patrimonioComputed;

  @override
  double get patrimonio =>
      (_$patrimonioComputed ??= Computed<double>(() => super.patrimonio,
              name: '_HomeControllerBase.patrimonio'))
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

  final _$lastUpdateAtom = Atom(name: '_HomeControllerBase.lastUpdate');

  @override
  String get lastUpdate {
    _$lastUpdateAtom.reportRead();
    return super.lastUpdate;
  }

  @override
  set lastUpdate(String value) {
    _$lastUpdateAtom.reportWrite(value, super.lastUpdate, () {
      super.lastUpdate = value;
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

  final _$acoesEmAltaAtom = Atom(name: '_HomeControllerBase.acoesEmAlta');

  @override
  List<CotacaoModel> get acoesEmAlta {
    _$acoesEmAltaAtom.reportRead();
    return super.acoesEmAlta;
  }

  @override
  set acoesEmAlta(List<CotacaoModel> value) {
    _$acoesEmAltaAtom.reportWrite(value, super.acoesEmAlta, () {
      super.acoesEmAlta = value;
    });
  }

  final _$acoesEmBaixaAtom = Atom(name: '_HomeControllerBase.acoesEmBaixa');

  @override
  List<CotacaoModel> get acoesEmBaixa {
    _$acoesEmBaixaAtom.reportRead();
    return super.acoesEmBaixa;
  }

  @override
  set acoesEmBaixa(List<CotacaoModel> value) {
    _$acoesEmBaixaAtom.reportWrite(value, super.acoesEmBaixa, () {
      super.acoesEmBaixa = value;
    });
  }

  final _$acoesEmAltaB3Atom = Atom(name: '_HomeControllerBase.acoesEmAltaB3');

  @override
  List<CotacaoModel> get acoesEmAltaB3 {
    _$acoesEmAltaB3Atom.reportRead();
    return super.acoesEmAltaB3;
  }

  @override
  set acoesEmAltaB3(List<CotacaoModel> value) {
    _$acoesEmAltaB3Atom.reportWrite(value, super.acoesEmAltaB3, () {
      super.acoesEmAltaB3 = value;
    });
  }

  final _$acoesEmBaixaB3Atom = Atom(name: '_HomeControllerBase.acoesEmBaixaB3');

  @override
  List<CotacaoModel> get acoesEmBaixaB3 {
    _$acoesEmBaixaB3Atom.reportRead();
    return super.acoesEmBaixaB3;
  }

  @override
  set acoesEmBaixaB3(List<CotacaoModel> value) {
    _$acoesEmBaixaB3Atom.reportWrite(value, super.acoesEmBaixaB3, () {
      super.acoesEmBaixaB3 = value;
    });
  }

  final _$fiisEmAltaAtom = Atom(name: '_HomeControllerBase.fiisEmAlta');

  @override
  List<CotacaoModel> get fiisEmAlta {
    _$fiisEmAltaAtom.reportRead();
    return super.fiisEmAlta;
  }

  @override
  set fiisEmAlta(List<CotacaoModel> value) {
    _$fiisEmAltaAtom.reportWrite(value, super.fiisEmAlta, () {
      super.fiisEmAlta = value;
    });
  }

  final _$fiisEmBaixaAtom = Atom(name: '_HomeControllerBase.fiisEmBaixa');

  @override
  List<CotacaoModel> get fiisEmBaixa {
    _$fiisEmBaixaAtom.reportRead();
    return super.fiisEmBaixa;
  }

  @override
  set fiisEmBaixa(List<CotacaoModel> value) {
    _$fiisEmBaixaAtom.reportWrite(value, super.fiisEmBaixa, () {
      super.fiisEmBaixa = value;
    });
  }

  final _$fiisEmAltaB3Atom = Atom(name: '_HomeControllerBase.fiisEmAltaB3');

  @override
  List<CotacaoModel> get fiisEmAltaB3 {
    _$fiisEmAltaB3Atom.reportRead();
    return super.fiisEmAltaB3;
  }

  @override
  set fiisEmAltaB3(List<CotacaoModel> value) {
    _$fiisEmAltaB3Atom.reportWrite(value, super.fiisEmAltaB3, () {
      super.fiisEmAltaB3 = value;
    });
  }

  final _$fiisEmBaixaB3Atom = Atom(name: '_HomeControllerBase.fiisEmBaixaB3');

  @override
  List<CotacaoModel> get fiisEmBaixaB3 {
    _$fiisEmBaixaB3Atom.reportRead();
    return super.fiisEmBaixaB3;
  }

  @override
  set fiisEmBaixaB3(List<CotacaoModel> value) {
    _$fiisEmBaixaB3Atom.reportWrite(value, super.fiisEmBaixaB3, () {
      super.fiisEmBaixaB3 = value;
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
lastUpdate: ${lastUpdate},
carteiras: ${carteiras},
acoesEmAlta: ${acoesEmAlta},
acoesEmBaixa: ${acoesEmBaixa},
acoesEmAltaB3: ${acoesEmAltaB3},
acoesEmBaixaB3: ${acoesEmBaixaB3},
fiisEmAlta: ${fiisEmAlta},
fiisEmBaixa: ${fiisEmBaixa},
fiisEmAltaB3: ${fiisEmAltaB3},
fiisEmBaixaB3: ${fiisEmBaixaB3},
patrimonio: ${patrimonio}
    ''';
  }
}
