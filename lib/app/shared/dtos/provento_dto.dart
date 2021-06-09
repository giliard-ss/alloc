import 'package:alloc/app/shared/models/provento_model.dart';

class ProventoDTO extends ProventoModel {
  int _qtd;

  ProventoDTO(ProventoModel model, this._qtd) : super.fromMap(model.toMap());

  double get valorTotal => _qtd.toDouble() * valorDouble;

  int get qtd => this._qtd;

  set qtd(int value) => this._qtd = value;
}
