import '../modelos/usuario_modelo.dart';

/// Fonte de dados local de autenticação (cache de sessão).
abstract interface class AutenticacaoLocalFonte {
  Future<void> salvarSessao({
    required String token,
    required UsuarioModelo usuario,
    String? cpf,
    String? dataNascimento,
    String? telefone,
  });

  Future<UsuarioModelo?> obterSessao();

  Future<String?> obterToken();

  Future<String?> obterCpf();

  Future<String?> obterDataNascimento();

  Future<String?> obterTelefone();

  Future<void> salvarTelefone(String telefone);

  Future<void> limparSessao();
}
