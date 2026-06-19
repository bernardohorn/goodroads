import 'dart:convert';

import '../../../../servicos/armazenamento_local_servico.dart';
import '../modelos/usuario_modelo.dart';
import 'autenticacao_local_fonte.dart';

/// Persistência local de sessão via SharedPreferences.
class AutenticacaoLocalFonteImpl implements AutenticacaoLocalFonte {
  AutenticacaoLocalFonteImpl(this._armazenamento);

  final ArmazenamentoLocalServico _armazenamento;

  static const String chaveToken = 'token_autenticacao';
  static const String chaveUsuario = 'usuario_sessao';
  static const String chaveCpf = 'usuario_cpf';
  static const String chaveDataNascimento = 'usuario_data_nascimento';

  @override
  Future<void> salvarSessao({
    required String token,
    required UsuarioModelo usuario,
    String? cpf,
    String? dataNascimento,
  }) async {
    await _armazenamento.salvar(chaveToken, token);
    await _armazenamento.salvar(
      chaveUsuario,
      jsonEncode(usuario.toJson()),
    );
    if (cpf != null) {
      await _armazenamento.salvar(chaveCpf, cpf);
    }
    if (dataNascimento != null) {
      await _armazenamento.salvar(chaveDataNascimento, dataNascimento);
    }
  }

  @override
  Future<UsuarioModelo?> obterSessao() async {
    final json = await _armazenamento.ler(chaveUsuario);
    if (json == null || json.isEmpty) return null;
    return UsuarioModelo.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
  }

  @override
  Future<String?> obterToken() => _armazenamento.ler(chaveToken);

  @override
  Future<String?> obterCpf() => _armazenamento.ler(chaveCpf);

  @override
  Future<String?> obterDataNascimento() =>
      _armazenamento.ler(chaveDataNascimento);

  @override
  Future<void> limparSessao() async {
    await _armazenamento.remover(chaveToken);
    await _armazenamento.remover(chaveUsuario);
    await _armazenamento.remover(chaveCpf);
    await _armazenamento.remover(chaveDataNascimento);
  }
}
