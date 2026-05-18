import 'package:dio/dio.dart';

import '../erros/excecoes.dart';

/// Converte erros do Dio em exceções de domínio/dados.
class InterceptadorErro extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      handler.reject(
        err.copyWith(error: const ExcecaoServidor('Tempo de conexão esgotado')),
      );
      return;
    }

    if (status != null && status >= 500) {
      handler.reject(
        err.copyWith(
          error: ExcecaoServidor(
            err.response?.data?['mensagem'] as String? ??
                'Erro no servidor ($status)',
          ),
        ),
      );
      return;
    }

    handler.next(err);
  }
}
