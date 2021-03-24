class BackupModel {
  String idUsuario;
  String papel;
  String idCarteira;
  double qtd;
  double preco;
  List<String> superiores;
  DateTime data;
  String tipo;

  BackupModel(String id, this.idUsuario, this.papel, this.idCarteira, int naoSei, this.qtd,
      this.preco, this.superiores, this.data, this.tipo, double preco2);

  //idUsuario, papel, idCarteira,qtd, preco,superiores, formatData, tipo, preco

}
