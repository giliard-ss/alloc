import 'package:alloc/app/cores/ativo_core.dart';
import 'package:alloc/app/shared/dtos/carteira_dto.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/carteira_model.dart';
import 'package:alloc/app/shared/models/usuario_model.dart';
import 'package:alloc/app/shared/services/carteira_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class CarteiraCore {
  ICarteiraService _carteiraService;
  UsuarioModel _usuario;
  var _carteirasDTO = Observable<List<CarteiraDTO>>([]);
  Observable<double> _reactionRefreshCarteira = Observable<double>(0);
  AtivoCore _ativoCore;

  CarteiraCore._(UsuarioModel usuario, AtivoCore ativoCore) {
    if (usuario == null || ativoCore == null)
      throw new ApplicationException("Instancias obrigatórias não informadas (Carteira)!");
    _usuario = usuario;
    _ativoCore = ativoCore;
    _carteiraService = Modular.get<CarteiraService>();
  }

  static Future<CarteiraCore> initInstance(UsuarioModel usuario, AtivoCore ativoCore) async {
    CarteiraCore carteiraCore = new CarteiraCore._(usuario, ativoCore);
    await carteiraCore.loadCarteiras();
    return carteiraCore;
  }

  Future<void> loadCarteiras({bool onlyCache = true}) async {
    await runInAction(() async {
      List<CarteiraModel> carteiras =
          await _carteiraService.getCarteiras(_usuario.id, onlyCache: onlyCache);
      List<CarteiraDTO> result = [];
      carteiras.forEach((e) => result.add(CarteiraDTO(e)));
      _carteirasDTO.value = result;
    });
  }

  void refreshCarteiraDTO() {
    runInAction(() {
      List<CarteiraDTO> carteiras = [];
      _carteirasDTO.value.forEach((carteira) {
        double totalAportadoAtivos = _ativoCore.getTotalAportadoAtivos(carteira.id);
        double rendimentoAtivos = _ativoCore.getRendimentoAtivos(carteira.id);

        carteira.totalAportado = totalAportadoAtivos;
        carteira.totalAportadoAtual = (totalAportadoAtivos + (rendimentoAtivos));
        carteiras.add(carteira);
      });
      _carteirasDTO.value = carteiras;
      _reactionRefreshCarteira.value = _reactionRefreshCarteira.value + 1;
    });
  }

  ///toda vez que _carteirasDTO sofrer alteracao de valor, executará a função em parametro
  ReactionDisposer createCarteirasReact(Function(double numReacao) func) {
    return reaction((_) => _reactionRefreshCarteira.value, func);
  }

  CarteiraDTO getCarteira(String carteiraId) {
    for (CarteiraDTO c in _carteirasDTO.value) {
      if (c.id == carteiraId) return c.clone();
    }
    throw new ApplicationException('Carteira $carteiraId não encontrada!');
  }

  List<CarteiraDTO> get carteiras {
    List<CarteiraDTO> result = [];
    _carteirasDTO.value.forEach((e) => result.add(e.clone()));
    return result;
  }
}
