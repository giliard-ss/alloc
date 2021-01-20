import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'sub_alocacao_controller.g.dart';

@Injectable()
class SubAlocacaoController = _SubAlocacaoControllerBase
    with _$SubAlocacaoController;

abstract class _SubAlocacaoControllerBase with Store {
  String _id;

  final CarteiraController _carteiraController = Modular.get();

  @observable
  List<AlocacaoDTO> alocacoes = [];

  Future<void> init() async {
    alocacoes = _carteiraController.allAlocacoes.value
        .where((e) => e.idSuperior == _id)
        .toList();
  }

  set id(String value) => _id = value;
}
