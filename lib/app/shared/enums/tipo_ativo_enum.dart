import 'package:alloc/app/shared/exceptions/application_exception.dart';

class TipoAtivo {
  static final _codigos = ["ACAO", "FIIS", "RENDA_FIXA", "CRIPTOMOEDA", "ETF"];
  String _code;

  @override
  String toString() {
    return _code;
  }

  String get code => _code;

  bool equals(TipoAtivo tipo) {
    return this._code == tipo.code;
  }

  TipoAtivo(String codigo) {
    int indexTipo = _codigos.indexOf(codigo);
    if (indexTipo == -1)
      throw ApplicationException("Tipo do ativo não encontrado ($codigo).");
    this._code = codigo;
  }

  static TipoAtivo get ACAO => TipoAtivo(_codigoAcao());
  static TipoAtivo get FIIS => TipoAtivo(_codigoFIIS());
  static TipoAtivo get RENDA_FIXA => TipoAtivo(_codigoRendaFixa());
  static TipoAtivo get CRIPTOMOEDA => TipoAtivo(_codigoCriptomoeda());
  static TipoAtivo get ETF => TipoAtivo(_codigoETF());

  bool isRendaVariavel() {
    return _code == _codigoAcao() ||
        _code == _codigoETF() ||
        _code == _codigoFIIS() ||
        _code == _codigoCriptomoeda();
  }

  bool isRendaFixa() {
    return _code == _codigoRendaFixa();
  }

  static String _codigoAcao() {
    return _codigos[0];
  }

  static String _codigoFIIS() {
    return _codigos[1];
  }

  static String _codigoRendaFixa() {
    return _codigos[2];
  }

  static String _codigoCriptomoeda() {
    return _codigos[3];
  }

  static String _codigoETF() {
    return _codigos[4];
  }
}
