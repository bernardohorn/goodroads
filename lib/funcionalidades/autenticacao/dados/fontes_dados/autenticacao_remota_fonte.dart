import '../modelos/resposta_autenticacao_modelo.dart';

/// Fonte de dados remota de autenticação (API REST).
abstract interface class AutenticacaoRemotaFonte {
  Future<RespostaAutenticacaoModelo> entrar({
    required String email,
    required String senha,
  });

  Future<RespostaAutenticacaoModelo> registrar({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
  });
}
