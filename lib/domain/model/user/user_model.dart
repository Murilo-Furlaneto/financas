import 'dart:convert';

class User {
  final String nome;
  final String email;
  final String senha;
 
  User({
    required this.nome,
    required this.email,
    required this.senha,
  });

  

  User copyWith({
    String? nome,
    String? email,
    String? senha,
  }) {
    return User(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
