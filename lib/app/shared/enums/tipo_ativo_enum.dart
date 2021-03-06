class TipoAtivo {
  String _code;

  @override
  String toString() {
    return _code;
  }

  String get code => _code;

  bool equals(TipoAtivo tipo) {
    return this._code == tipo.code;
  }

  TipoAtivo(this._code);

  static TipoAtivo get ACAO => TipoAtivo("ACAO");
  static TipoAtivo get FII => TipoAtivo("FII");
  static TipoAtivo get RF => TipoAtivo("RF");
  static TipoAtivo get CRIPTO => TipoAtivo("CRIPTO");
  static TipoAtivo get ETF => TipoAtivo("ETF");
}
