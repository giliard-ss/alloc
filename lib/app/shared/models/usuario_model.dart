class UsuarioModel {
  String _id;
  String _nome;
  String _email;

  UsuarioModel(this._id, this._nome, this._email);

  UsuarioModel.fromMap(Map map) {
    this._id = map['id'];
    this._email = map['email'];
    this._nome = map['nome'];
  }

  String get nome => _nome;

  set nome(String value) => _nome = value;

  String get email => _email;

  set email(String value) => _email = value;

  String get id => _id;

  set id(String value) => _id = value;
}
