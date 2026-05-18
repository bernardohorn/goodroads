import '../../dominio/entidades/usuario_entidade.dart';

/// Modelo de dados do usuário (serialização futura com API/Firebase).
class UsuarioModelo {
  const UsuarioModelo({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoUrl,
    this.papel,
  });

  final String id;
  final String nome;
  final String email;
  final String? fotoUrl;
  final String? papel;

  factory UsuarioModelo.fromJson(Map<String, dynamic> json) {
    return UsuarioModelo(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      fotoUrl: json['foto_url'] as String?,
      papel: json['papel'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'foto_url': fotoUrl,
        'papel': papel,
      };

  UsuarioEntidade toEntidade() => UsuarioEntidade(
        id: id,
        nome: nome,
        email: email,
        fotoUrl: fotoUrl,
        papel: papel,
      );

  factory UsuarioModelo.fromEntidade(UsuarioEntidade entidade) {
    return UsuarioModelo(
      id: entidade.id,
      nome: entidade.nome,
      email: entidade.email,
      fotoUrl: entidade.fotoUrl,
      papel: entidade.papel,
    );
  }
}
