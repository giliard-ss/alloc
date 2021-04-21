import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/config/backup_vendas.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/models/evento_venda_renda_variavel.dart';
import 'package:alloc/app/shared/services/event_service.dart';
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
  IEventService _eventService = Modular.get<EventService>();

  @observable
  String error = "";

  DateTime data = DateTime.now();
  @observable
  String papel;
  double qtd;
  double preco;
  double custos = 0.0;

  @action
  Future<bool> comprar() async {
    try {
      if (!papelValido) {
        error = "Papel não encontrado.";
        return false;
      }

      if (preco == 0 || preco == null) {
        error = "Informe a cotação!";
        return false;
      }

      AbstractEvent aplicacaoEvent = createEventAplicacaoRendaVariavel();
      await _eventService.save(aplicacaoEvent);

      await AppCore.notifyAddDelEvent();
      return true;
    } on ApplicationException catch (e) {
      error = e.toString();
    } catch (e) {
      error = "Falha ao finalizar compra!";
      LoggerUtil.error(e);
    }
    return false;
  }

  Future<void> backupVendas() async {
    List<VendaRendaVariavelEvent> vendas = BackupVendas.getVendas();
    for (VendaRendaVariavelEvent venda in vendas) {
      await _eventService.save(venda);
    }
  }

  AbstractEvent createEventAplicacaoRendaVariavel() {
    return AplicacaoRendaVariavel(null, data, _carteiraController.carteira.id, AppCore.usuario.id,
        preco * qtd, getIdSuperiores(), papel, qtd);
  }

  @computed
  bool get papelValido {
    return AppCore.allPapeis.where((e) => e == papel).isNotEmpty;
  }

  @action
  void setPapel(String papel) {
    this.papel = papel;
  }

  List<String> getSugestoes(String text) {
    if (text.trim().isEmpty || text.trim().length < 2) return null;
    return TipoAtivo.allTickets()
        .where((e) => e.toUpperCase().indexOf(text.trim().toUpperCase()) >= 0)
        .toList();
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
      if (!papelValido) {
        error = "Papel não encontrado.";
        return false;
      }

      if (preco == 0 || preco == null) {
        error = "Informe a cotação!";
        return false;
      }

      AtivoDTO ativo = AppCore.getAtivo(
          _carteiraController.carteira.id, _alocacaoAtual == null ? "" : _alocacaoAtual.id, papel);

      AbstractEvent venda = VendaRendaVariavelEvent(null, data, _carteiraController.carteira.id,
          AppCore.usuario.id, ativo.precoMedio * qtd, preco * qtd, getIdSuperiores(), papel, qtd,
          custos: custos);

      await _eventService.save(venda);
      await AppCore.notifyAddDelEvent();
      return true;
    } on ApplicationException catch (e) {
      error = e.toString();
    } catch (e) {
      error = "Falha ao finalizar venda!";
      LoggerUtil.error(e);
    }
    return false;
  }

  AlocacaoDTO _getAlocacaoDTO(String id) {
    return AppCore.getAlocacaoById(id);
  }

  void setAlocacaoAtual(String idAlocacao) {
    if (!StringUtil.isEmpty(idAlocacao)) {
      _alocacaoAtual = _getAlocacaoDTO(idAlocacao);
    }
  }
}
