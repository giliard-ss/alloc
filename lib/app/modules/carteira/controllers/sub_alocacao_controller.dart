import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'sub_alocacao_controller.g.dart';

@Injectable()
class SubAlocacaoController = _SubAlocacaoControllerBase
    with _$SubAlocacaoController;

abstract class _SubAlocacaoControllerBase with Store {
  String _id;

  final CarteiraController _carteiraController = Modular.get();

  Observable<List<AlocacaoDTO>> alocacoes = Observable<List<AlocacaoDTO>>([]);

  Future<void> init() async {
    // try {
    //   alocacoes.value = _carteiraController.allAlocacoes.value
    //       .where((e) => e.idSuperior == _id)
    //       .toList();
    // } catch (e) {
    //   LoggerUtil.error(e);
    // }
  }

  set id(String value) => _id = value;
}
