import 'package:dio/dio.dart';

import '../modelos/resposta_autenticacao_modelo.dart';
import '../modelos/usuario_modelo.dart';
import 'autenticacao_remota_fonte.dart';

/// Implementação real da fonte remota de autenticação (API REST).
class AutenticacaoRemotaFonteImpl implements AutenticacaoRemotaFonte {
  AutenticacaoRemotaFonteImpl(this._dio);

  final Dio _dio;

  static const String _base = '/auth';

  @override
  Future<RespostaAutenticacaoModelo> entrar({
    required String email,
    required String senha,
  }) async {
    final resposta = await _dio.post<Map<String, dynamic>>(
      '$_base/login',
      data: {'email': email.trim(), 'senha': senha},
    );
    return RespostaAutenticacaoModelo.fromJson(resposta.data!);
  }

  @override
  Future<RespostaAutenticacaoModelo> registrar({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
  }) async {
    final resposta = await _dio.post<Map<String, dynamic>>(
      '$_base/registro',
      data: {
        'nome': nome.trim(),
        'email': email.trim().toLowerCase(),
        'senha': senha,
        if (telefone != null && telefone.isNotEmpty) 'telefone': telefone,
      },
    );
    return RespostaAutenticacaoModelo.fromJson(resposta.data!);
  }
}
