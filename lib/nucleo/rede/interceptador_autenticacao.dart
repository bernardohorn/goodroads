import 'package:dio/dio.dart';

/// Injeta token de autenticação nas requisições (implementação futura).
class InterceptadorAutenticacao extends Interceptor {
  InterceptadorAutenticacao({this.obterToken});

  final Future<String?> Function()? obterToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await obterToken?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
