import 'evento.dart';

class EventoResgate extends Evento {
  double _valor;
  double custos;
  List<String> _superiores;
  String _tipoAtivo;

  EventoResgate(String id, DateTime data, String carteiraId, this._valor,
      this.custos, this._superiores, this._tipoAtivo, String usuarioId)
      : super(
            id, data.millisecondsSinceEpoch, carteiraId, "RESGATE", usuarioId);
}
