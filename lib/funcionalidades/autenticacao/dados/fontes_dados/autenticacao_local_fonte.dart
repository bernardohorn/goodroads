import '../modelos/usuario_modelo.dart';

/// Fonte de dados local de autenticação (cache de sessão).
abstract interface class AutenticacaoLocalFonte {
  Future<void> salvarSessao(UsuarioModelo usuario);

  Future<UsuarioModelo?> obterSessao();

  Future<void> limparSessao();
}
