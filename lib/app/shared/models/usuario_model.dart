class UsuarioModel {
  String _id;
  String _nome;
  String _email;
  String _photoURL;
  String _photoBase64;

  UsuarioModel(this._id, this._nome, this._email, this._photoURL,
      [this._photoBase64]);

  UsuarioModel.fromMap(Map map) {
    this._id = map['id'];
    this._email = map['email'];
    this._nome = map['nome'];
    this._photoURL = map['photoURL'];
    this._photoBase64 = map['photoBase64'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'email': this._email,
      'nome': this._nome,
      'photoURL': this._photoURL,
      'photoBase64': this._photoBase64
    };
  }

  String get nome => _nome;

  set nome(String value) => _nome = value;

  String get email => _email;

  set email(String value) => _email = value;

  String get id => _id;

  set id(String value) => _id = value;

  String get photoURL => this._photoURL;

  set photoURL(String value) => _photoURL = value;

  String get photoBase64 => this._photoBase64;

  set photoBase64(String value) => _photoBase64 = value;
}
