import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/erros/falha.dart';
import '../../dominio/entidades/usuario_entidade.dart';
import '../../dominio/repositorios/autenticacao_repositorio.dart';
import '../fontes_dados/autenticacao_local_fonte.dart';
import '../fontes_dados/autenticacao_remota_fonte.dart';
import '../modelos/usuario_modelo.dart';

/// Implementação do repositório de autenticação (stub para desenvolvimento).
class AutenticacaoRepositorioImpl implements AutenticacaoRepositorio {
  AutenticacaoRepositorioImpl({
    required AutenticacaoRemotaFonte remota,
    required AutenticacaoLocalFonte local,
  })  : _remota = remota,
        _local = local;

  final AutenticacaoRemotaFonte _remota;
  final AutenticacaoLocalFonte _local;

  UsuarioEntidade? _usuarioEmMemoria;

  @override
  Future<Resultado<UsuarioEntidade>> entrar({
    required String email,
    required String senha,
  }) async {
    try {
      final modelo = await _remota.entrar(email: email, senha: senha);
      await _local.salvarSessao(modelo);
      _usuarioEmMemoria = modelo.toEntidade();
      return Sucesso(_usuarioEmMemoria!);
    } catch (_) {
      return const Erro(FalhaAutenticacao());
    }
  }

  @override
  Future<Resultado<UsuarioEntidade>> registrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final modelo = await _remota.registrar(
        nome: nome,
        email: email,
        senha: senha,
      );
      await _local.salvarSessao(modelo);
      _usuarioEmMemoria = modelo.toEntidade();
      return Sucesso(_usuarioEmMemoria!);
    } catch (_) {
      return const Erro(FalhaDesconhecida());
    }
  }

  @override
  Future<void> sair() async {
    _usuarioEmMemoria = null;
    await _local.limparSessao();
  }

  @override
  Future<UsuarioEntidade?> obterUsuarioAtual() async {
    if (_usuarioEmMemoria != null) return _usuarioEmMemoria;
    final sessao = await _local.obterSessao();
    return sessao?.toEntidade();
  }
}

/// Stub da fonte remota para desenvolvimento inicial.
class AutenticacaoRemotaFonteStub implements AutenticacaoRemotaFonte {
  @override
  Future<UsuarioModelo> entrar({
    required String email,
    required String senha,
  }) async {
    return UsuarioModelo(
      id: '1',
      nome: 'Usuário GRB',
      email: email,
      papel: 'agente',
    );
  }

  @override
  Future<UsuarioModelo> registrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    return UsuarioModelo(
      id: '1',
      nome: nome,
      email: email,
      papel: 'agente',
    );
  }
}

/// Stub da fonte local para desenvolvimento inicial.
class AutenticacaoLocalFonteStub implements AutenticacaoLocalFonte {
  UsuarioModelo? _sessao;

  @override
  Future<void> salvarSessao(UsuarioModelo usuario) async {
    _sessao = usuario;
  }

  @override
  Future<UsuarioModelo?> obterSessao() async => _sessao;

  @override
  Future<void> limparSessao() async {
    _sessao = null;
  }
}
