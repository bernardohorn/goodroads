import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/erros/falha.dart';
import '../../dominio/entidades/usuario_entidade.dart';
import '../../dominio/repositorios/autenticacao_repositorio.dart';
import '../fontes_dados/autenticacao_firebase_fonte.dart';
import '../fontes_dados/autenticacao_local_fonte.dart';
import '../fontes_dados/autenticacao_remota_fonte.dart';

/// Implementação do repositório de autenticação (Firebase Auth + API REST/PostgreSQL).
class AutenticacaoRepositorioImpl implements AutenticacaoRepositorio {
  AutenticacaoRepositorioImpl({
    required AutenticacaoRemotaFonte remota,
    required AutenticacaoLocalFonte local,
    required AutenticacaoFirebaseFonte firebase,
  })  : _remota = remota,
        _local = local,
        _firebase = firebase;

  final AutenticacaoRemotaFonte _remota;
  final AutenticacaoLocalFonte _local;
  final AutenticacaoFirebaseFonte _firebase;

  UsuarioEntidade? _usuarioEmMemoria;

  @override
  Future<Resultado<UsuarioEntidade>> entrar({
    required String email,
    required String senha,
  }) async {
    try {
      if (_firebase.disponivel) {
        final falhaFirebase = await _firebase.entrar(
          email: email,
          senha: senha,
        );
        if (falhaFirebase != null) {
          return Erro(falhaFirebase);
        }
      }

      final resposta = await _remota.entrar(email: email, senha: senha);
      await _local.salvarSessao(
        token: resposta.token,
        usuario: resposta.usuario,
      );
      _usuarioEmMemoria = resposta.usuario.toEntidade();
      return Sucesso(_usuarioEmMemoria!);
    } on DioException catch (e) {
      debugPrint('[GoodRoads] Erro ao entrar: ${e.message}');
      return Erro(_mapearErroDio(e, padrao: const FalhaAutenticacao()));
    } catch (e) {
      debugPrint('[GoodRoads] Erro inesperado ao entrar: $e');
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
      if (_firebase.disponivel) {
        final falhaFirebase = await _firebase.registrar(
          email: email,
          senha: senha,
        );
        if (falhaFirebase != null) {
          return Erro(falhaFirebase);
        }
      }

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
      debugPrint('[GoodRoads] Erro ao registrar: ${e.message}');
      return Erro(_mapearErroDio(e));
    } catch (e) {
      debugPrint('[GoodRoads] Erro inesperado ao registrar: $e');
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

  Falha _mapearErroDio(
    DioException e, {
    Falha padrao = const FalhaDesconhecida(),
  }) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout
          ? const FalhaTimeout()
          : const FalhaRede();
    }

    final codigo = e.response?.statusCode;
    final corpo = e.response?.data;

    if (corpo is Map) {
      final mensagem =
          (corpo['erro'] ?? corpo['message'] ?? corpo['error']) as String?;
      if (mensagem != null && mensagem.isNotEmpty) {
        if (codigo == 409 ||
            mensagem.toLowerCase().contains('email') ||
            mensagem.toLowerCase().contains('já cadastrado') ||
            mensagem.toLowerCase().contains('already')) {
          return FalhaEmailJaCadastrado(mensagem);
        }
        return FalhaDesconhecida(mensagem);
      }
    }

    return switch (codigo) {
      400 => const FalhaDesconhecida('Dados inválidos. Verifique os campos.'),
      401 => const FalhaAutenticacao(),
      403 => const FalhaNaoAutorizado(),
      409 => const FalhaEmailJaCadastrado(),
      final int c when c >= 500 => const FalhaServidor(),
      _ => padrao,
    };
  }
}
