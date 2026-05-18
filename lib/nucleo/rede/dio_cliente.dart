import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'cliente_http.dart';
import 'interceptador_autenticacao.dart';
import 'interceptador_erro.dart';

/// Implementação do [ClienteHttp] utilizando Dio.
class DioCliente implements ClienteHttp {
  DioCliente(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> get(String caminho) async {
    final resposta = await _dio.get<Map<String, dynamic>>(caminho);
    return resposta.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> post(
    String caminho, {
    Map<String, dynamic>? corpo,
  }) async {
    final resposta = await _dio.post<Map<String, dynamic>>(
      caminho,
      data: corpo,
    );
    return resposta.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> put(
    String caminho, {
    Map<String, dynamic>? corpo,
  }) async {
    final resposta = await _dio.put<Map<String, dynamic>>(
      caminho,
      data: corpo,
    );
    return resposta.data ?? {};
  }

  @override
  Future<void> delete(String caminho) async {
    await _dio.delete<void>(caminho);
  }
}

/// Cria instância do Dio com interceptadores padrão.
Dio criarDio({
  required String urlBase,
  Duration tempoLimite = const Duration(seconds: 30),
  Future<String?> Function()? obterToken,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: urlBase,
      connectTimeout: tempoLimite,
      receiveTimeout: tempoLimite,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    InterceptadorAutenticacao(obterToken: obterToken),
    InterceptadorErro(),
    if (kDebugMode)
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
  ]);

  return dio;
}
