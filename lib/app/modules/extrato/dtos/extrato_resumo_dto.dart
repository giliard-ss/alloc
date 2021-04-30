class ExtratoResumoDTO {
  String _descricao;
  double _valor;

  ExtratoResumoDTO(this._descricao, this._valor);
  String get descricao => this._descricao;

  set descricao(String value) => this._descricao = value;

  get valor => this._valor;

  set valor(value) => this._valor = value;
}
