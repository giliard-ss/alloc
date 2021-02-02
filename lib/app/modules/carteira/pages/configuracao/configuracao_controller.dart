import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/alocacao_model.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'configuracao_controller.g.dart';

@Injectable()
class ConfiguracaoController = _ConfiguracaoControllerBase
    with _$ConfiguracaoController;

abstract class _ConfiguracaoControllerBase with Store {
  CarteiraController _carteiraController = Modular.get();
  String superiorId;

  @observable
  List<AlocacaoDTO> alocacoes = [];
  @observable
  List<AtivoModel> ativos = [];

  Future<void> init() async {
    _loadAlocacoesOuAtivos();
  }

  void _loadAlocacoesOuAtivos() {
    _loadAlocacoes();
    if (alocacoes.isEmpty) {
      _loadAtivos();
    }
  }

  void _loadAtivos() {
    runInAction(() {
      ativos = SharedMain.ativos
          .where(
            (e) => StringUtil.isEmpty(superiorId)
                ? e.superiores.isEmpty
                : e.superiores.contains(superiorId),
          )
          .toList();
    });
  }

  void _loadAlocacoes() {
    alocacoes = _carteiraController.allAlocacoes.value
        .where(
          (e) => e.idSuperior == superiorId,
        )
        .toList();
  }
}
