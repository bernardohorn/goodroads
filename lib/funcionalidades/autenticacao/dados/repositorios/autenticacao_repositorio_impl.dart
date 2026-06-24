import 'package:dio/dio.dart';

import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/erros/falha.dart';
import '../../dominio/entidades/usuario_entidade.dart';
import '../../dominio/repositorios/autenticacao_repositorio.dart';
import '../fontes_dados/autenticacao_local_fonte.dart';
import '../fontes_dados/autenticacao_remota_fonte.dart';

/// Implementação do repositório de autenticação conectada à API REST.
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
      final resposta = await _remota.entrar(email: email, senha: senha);
      await _local.salvarSessao(
        token: resposta.token,
        usuario: resposta.usuario,
      );
      _usuarioEmMemoria = resposta.usuario.toEntidade();
      return Sucesso(_usuarioEmMemoria!);
    } on DioException catch (e) {
      return Erro(_mapearErroDio(e, padrao: const FalhaAutenticacao()));
    } catch (_) {
      return const Erro(FalhaDesconhecida());
    }
  }

  @override
  Future<Resultado<UsuarioEntidade>> registrar({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
    String? cpf,
    String? dataNascimento,
  }) async {
    try {
      final resposta = await _remota.registrar(
        nome: nome,
        email: email,
        senha: senha,
        telefone: telefone,
      );
      await _local.salvarSessao(
        token: resposta.token,
        usuario: resposta.usuario,
        cpf: cpf,
        dataNascimento: dataNascimento,
      );
      _usuarioEmMemoria = resposta.usuario.toEntidade();
      return Sucesso(_usuarioEmMemoria!);
    } on DioException catch (e) {
      return Erro(_mapearErroDio(e));
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
    final token = await _local.obterToken();
    if (token == null || token.isEmpty) return null;
    final sessao = await _local.obterSessao();
    _usuarioEmMemoria = sessao?.toEntidade();
    return _usuarioEmMemoria;
  }

  Future<String?> obterCpfLocal() => _local.obterCpf();

  Future<String?> obterDataNascimentoLocal() => _local.obterDataNascimento();

  Future<String?> obterTelefoneLocal() => _local.obterTelefone();

  Future<void> salvarTelefoneLocal(String telefone) =>
      _local.salvarTelefone(telefone);

  Falha _mapearErroDio(DioException e, {Falha padrao = const FalhaDesconhecida()}) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const FalhaRede();
    }
    final mensagem = e.response?.data;
    if (mensagem is Map && mensagem['erro'] is String) {
      return FalhaDesconhecida(mensagem['erro'] as String);
    }
    final codigo = e.response?.statusCode;
    if (codigo == 401) return const FalhaAutenticacao();
    if (codigo != null && codigo >= 500) return const FalhaServidor();
    return padrao;
  }
}
