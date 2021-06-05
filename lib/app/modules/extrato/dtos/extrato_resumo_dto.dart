import 'package:alloc/app/shared/enums/tipo_evento_enum.dart';

class ExtratoResumoDTO {
  String _descricao;
  double _valor;
  TipoEvento _tipoEvento;

  ExtratoResumoDTO(this._descricao, this._valor, this._tipoEvento);
  String get descricao => this._descricao;

  set descricao(String value) => this._descricao = value;

  get valor => this._valor;

  set valor(value) => this._valor = value;

  get tipoEvento => this._tipoEvento;

  set tipoEvento(value) => this._tipoEvento = value;
}
