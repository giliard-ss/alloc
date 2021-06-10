import 'package:alloc/app/shared/exceptions/application_exception.dart';

class TipoEvento {
  static final _codigos = ["APLICACAO", "DEPOSITO", "PROVENTO", "SAQUE", "VENDA"];
  static final _descricoes = ["Aplicação", "Depósito", "Provento", "Saque", "Venda"];
  static final _descricoesPlural = ["Aplicações", "Depósitos", "Proventos", "Saques", "Vendas"];
  String _code;
  String _descricao;
  String _descricaoPlural;

  @override
  String toString() {
    return _code;
  }

  String get code => _code;

  String get descricaoPlural => this._descricaoPlural;

  String get descricao => this._descricao;

  bool equals(TipoEvento tipo) {
    return this._code == tipo.code;
  }

  TipoEvento(String codigo) {
    int indexTipo = _codigos.indexOf(codigo);
    if (indexTipo == -1) throw ApplicationException("Tipo do evento não encontrado ($codigo).");
    this._code = codigo;
    this._descricao = _descricoes[indexTipo];
    this._descricaoPlural = _descricoesPlural[indexTipo];
  }

  static TipoEvento get APLICACAO => TipoEvento(_codigoAplicacao());
  static TipoEvento get DEPOSITO => TipoEvento(_codigoDeposito());
  static TipoEvento get PROVENTO => TipoEvento(_codigoProvento());
  static TipoEvento get SAQUE => TipoEvento(_codigoSaque());
  static TipoEvento get VENDA => TipoEvento(_codigoVenda());

  static String _codigoAplicacao() {
    return _codigos[0];
  }

  static String _codigoDeposito() {
    return _codigos[1];
  }

  static String _codigoProvento() {
    return _codigos[2];
  }

  static String _codigoSaque() {
    return _codigos[3];
  }

  static String _codigoVenda() {
    return _codigos[4];
  }
}
