import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
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
  @observable
  double percentualRestante = 0;

  Future<void> init() async {
    _loadAlocacoesOuAtivos();
    checkAlocacoesValues();
  }

  void _loadAlocacoesOuAtivos() {
    _loadAlocacoes();
    if (alocacoes.isEmpty) {
      _loadAtivos();
    }
  }

  void _loadAtivos() {
    runInAction(() {
      ativos = List.from(SharedMain.ativos
          .where(
            (e) => StringUtil.isEmpty(superiorId)
                ? e.superiores.isEmpty
                : e.superiores.contains(superiorId),
          )
          .toList());
    });
  }

  @action
  void checkAlocacoesValues() {
    double percentualTotal = 0;
    alocacoes.forEach((e) {
      percentualTotal += e.alocacaoPercent.toDouble();
    });
    percentualRestante =
        double.parse(((100 - percentualTotal)).toStringAsFixed(2));
    //percentualRestante = percentualTotal > 100 ? 0 : (100 - percentualTotal);
  }

  @action
  void checkAtivosValues() {
    double percentualTotal = 0;
    ativos.forEach((e) {
      percentualTotal += e.alocacaoPercent.toDouble();
    });
    percentualRestante =
        double.parse(((100 - percentualTotal)).toStringAsFixed(2));
    //percentualRestante = percentualTotal > 100 ? 0 : (100 - percentualTotal);
  }

  void salvar() {
    print('teste00');
  }

  void _loadAlocacoes() {
    alocacoes = List.from(_carteiraController.allAlocacoes.value
        .where(
          (e) => e.idSuperior == superiorId,
        )
        .toList());
  }
}
