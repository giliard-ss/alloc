import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/backup.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/services/iativo_service.dart';
import 'package:alloc/app/shared/services/impl/ativo_service.dart';
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
  @observable
  String tipo = "ACAO";

  DateTime data = DateTime.now();
  String papel;
  double qtd;
  double preco;

  @action
  Future<bool> comprar() async {
    try {
      AtivoModel ativo = AtivoModel();
      ativo.idCarteira = _carteiraController.carteira.id;
      ativo.idUsuario = AppCore.usuario.id;
      ativo.papel = papel;
      ativo.precoMedio = preco == null ? 0.0 : preco;
      ativo.qtd = qtd;
      ativo.dataRecente = data;
      ativo.superiores = getIdSuperiores();
      ativo.tipo = tipo;

      List<AtivoDTO> dtos = _alocacaoAtual == null
          ? AppCore.getAtivosByCarteira(_carteiraController.carteira.id)
          : AppCore.getAtivosByIdSuperior(_alocacaoAtual.id);

      List<AtivoModel> ativos = [];
      dtos.forEach((e) => ativos.add(AtivoModel.fromMap(e.toMap())));

      ativos.add(ativo);
      _ativoService.save(
          ativos,
          _alocacaoAtual == null
              ? _carteiraController.carteira.autoAlocacao
              : _alocacaoAtual.autoAlocacao);
      await AppCore.notifyAddDelAtivo();
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
  Future<bool> vender() async {
    try {
      //List<AtivoModel> list = Backup.getAllAtivos();
      //_ativoService.save(list, true);

      //AppCore.allAtivos.forEach((e) => _ativoService.delete(e, [], false));
      await AppCore.notifyAddDelAtivo();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @action
  void changeTipo(String value) => tipo = value;

  AlocacaoDTO _getAlocacaoDTO(String id) {
    return AppCore.getAlocacaoById(id);
  }

  void setAlocacaoAtual(String idAlocacao) {
    if (!StringUtil.isEmpty(idAlocacao)) {
      _alocacaoAtual = _getAlocacaoDTO(idAlocacao);
    }
  }
}
