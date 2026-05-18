import '../../../../compartilhado/modelos/resultado.dart';
import '../entidades/usuario_entidade.dart';
import '../repositorios/autenticacao_repositorio.dart';

/// Caso de uso: realizar login.
class EntrarCasoUso {
  const EntrarCasoUso(this._repositorio);

  final AutenticacaoRepositorio _repositorio;

  Future<Resultado<UsuarioEntidade>> executar({
    required String email,
    required String senha,
  }) {
    return _repositorio.entrar(email: email, senha: senha);
  }
}
