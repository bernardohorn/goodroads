/// Entidade de perfil do usuário.
class PerfilEntidade {
  const PerfilEntidade({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.fotoUrl,
  });

  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final String? fotoUrl;
}
