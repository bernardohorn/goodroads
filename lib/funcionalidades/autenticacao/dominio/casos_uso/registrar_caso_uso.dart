import '../../../../compartilhado/modelos/resultado.dart';
import '../entidades/usuario_entidade.dart';
import '../repositorios/autenticacao_repositorio.dart';

/// Caso de uso: registrar novo usuário.
class RegistrarCasoUso {
  const RegistrarCasoUso(this._repositorio);

  final AutenticacaoRepositorio _repositorio;

  Future<Resultado<UsuarioEntidade>> executar({
    required String nome,
    required String email,
    required String senha,
  }) {
    return _repositorio.registrar(nome: nome, email: email, senha: senha);
  }
}
