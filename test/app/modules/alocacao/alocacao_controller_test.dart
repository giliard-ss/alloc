import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alloc/app/modules/alocacao/alocacao_controller.dart';
import 'package:alloc/app/modules/alocacao/alocacao_module.dart';

void main() {
  initModule(AlocacaoModule());
  // AlocacaoController alocacao;
  //
  setUp(() {
    //     alocacao = AlocacaoModule.to.get<AlocacaoController>();
  });

  group('AlocacaoController Test', () {
    //   test("First Test", () {
    //     expect(alocacao, isInstanceOf<AlocacaoController>());
    //   });

    //   test("Set Value", () {
    //     expect(alocacao.value, equals(0));
    //     alocacao.increment();
    //     expect(alocacao.value, equals(1));
    //   });
  });
}
