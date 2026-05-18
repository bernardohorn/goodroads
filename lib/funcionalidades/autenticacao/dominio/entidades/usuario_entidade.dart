/// Entidade de usuário no domínio.
class UsuarioEntidade {
  const UsuarioEntidade({
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
}
