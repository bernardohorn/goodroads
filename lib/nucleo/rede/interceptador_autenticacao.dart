import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Injeta token de autenticação nas requisições (implementação futura).
class InterceptadorAutenticacao extends Interceptor {
  InterceptadorAutenticacao({this.obterToken});

  final Future<String?> Function()? obterToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint('[InterceptadorAutenticacao] onRequest chamado para: ${options.uri}');
    debugPrint('[InterceptadorAutenticacao] obterToken: ${obterToken != null}');
    
    final token = await obterToken?.call();
    debugPrint('[InterceptadorAutenticacao] Token retornado: ${token != null ? "${token.substring(0, 20)}..." : "null"}');
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('[InterceptadorAutenticacao] Authorization header adicionado');
    } else {
      debugPrint('[InterceptadorAutenticacao] Token null ou vazio - header não adicionado');
    }
    
    handler.next(options);
  }
}
