import '../modelos/usuario_modelo.dart';

/// Fonte de dados remota de autenticação (API/Firebase — implementação futura).
abstract interface class AutenticacaoRemotaFonte {
  Future<UsuarioModelo> entrar({
    required String email,
    required String senha,
  });

  Future<UsuarioModelo> registrar({
    required String nome,
    required String email,
    required String senha,
  });
}
