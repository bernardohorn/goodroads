import '../../../../compartilhado/modelos/resultado.dart';
import '../entidades/usuario_entidade.dart';

/// Contrato do repositório de autenticação.
abstract interface class AutenticacaoRepositorio {
  Future<Resultado<UsuarioEntidade>> entrar({
    required String email,
    required String senha,
  });

  Future<Resultado<UsuarioEntidade>> registrar({
    required String nome,
    required String email,
    required String senha,
  });

  Future<void> sair();

  Future<UsuarioEntidade?> obterUsuarioAtual();
}
