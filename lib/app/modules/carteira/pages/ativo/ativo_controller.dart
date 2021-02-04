import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/modules/carteira/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/services/impl/ativo_service.dart';
import 'package:alloc/app/shared/shared_main.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'ativo_controller.g.dart';

@Injectable()
class AtivoController = _AtivoControllerBase with _$AtivoController;

abstract class _AtivoControllerBase with Store {
  CarteiraController _carteiraController = Modular.get();
  AlocacaoDTO _alocacaoAtual;
  IAtivoService _ativoService = Modular.get<AtivoService>();

  @observable
  String error = "";

  DateTime data = DateTime.now();
  String papel;
  int qtd;
  double preco;

  @action
  Future<bool> comprar() async {
    try {
      AtivoModel ativo = AtivoModel();
      ativo.idCarteira = _carteiraController.carteira.id;
      ativo.idUsuario = SharedMain.usuario.id;
      ativo.papel = papel;
      ativo.preco = preco;
      ativo.qtd = qtd;
      ativo.data = data;
      ativo.superiores = getIdSuperiores();

      List ativos = SharedMain.ativos
          .where(
            (e) => _alocacaoAtual == null
                ? e.idCarteira == _carteiraController.carteira.id
                : e.superiores.contains(_alocacaoAtual.id),
          )
          .toList();

      ativos.add(ativo);
      await _ativoService.save(
          ativos,
          _alocacaoAtual == null
              ? _carteiraController.carteira.autoAlocacao
              : _alocacaoAtual.autoAlocacao);
      await SharedMain.refreshAtivos();
      return true;
    } catch (e) {
      error = "Falha ao finalizar compra!";
      LoggerUtil.error(e);
      return false;
    }
  }

  List<String> getIdSuperiores() {
    if (_alocacaoAtual != null) {
      List<String> result = [_alocacaoAtual.id];

      AlocacaoDTO superior = _alocacaoAtual;
      while (superior != null) {
        if (StringUtil.isEmpty(superior.idSuperior)) {
          break;
        } else {
          result.add(superior.idSuperior);
          superior = _getAlocacaoDTO(superior.idSuperior);
        }
      }
      return result;
    } else {
      return [];
    }
  }

  @action
  Future<bool> vender() {}

  AlocacaoDTO _getAlocacaoDTO(String id) {
    return _carteiraController.allAlocacoes.value.firstWhere((e) => e.id == id);
  }

  void setAlocacaoAtual(String idAlocacao) {
    if (!StringUtil.isEmpty(idAlocacao)) {
      _alocacaoAtual = _getAlocacaoDTO(idAlocacao);
    }
  }
}
