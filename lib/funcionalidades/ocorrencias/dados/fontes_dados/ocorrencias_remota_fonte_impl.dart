import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';

import '../modelos/ocorrencia_modelo.dart';
import 'ocorrencias_remota_fonte.dart';

/// Fonte remota de ocorrências conectada à API REST do GoodRoads.
class OcorrenciasRemotaFonteImpl implements OcorrenciasRemotaFonte {
  OcorrenciasRemotaFonteImpl(this._dio);

  final Dio _dio;

  static const String _base = '/ocorrencias';
  static const String _debugFile = 'debug_output.txt';

  Future<void> _logDebug(String message) async {
    try {
      final file = File(_debugFile);
      final timestamp = DateTime.now().toIso8601String();
      await file.writeAsString('[$timestamp] $message\n', mode: FileMode.append);
      debugPrint(message); // Also print to console for immediate visibility
    } catch (e) {
      debugPrint('Erro ao escrever log: $e');
    }
  }

  Map<String, dynamic>? _decodeJwtPayload(String? token) {
    if (token == null || token.isEmpty) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<OcorrenciaModelo>> listar() async {
    await _logDebug('=== LISTAR OCORRÊNCIAS - REQUEST ===');
    await _logDebug('URL: ${_dio.options.baseUrl}$_base');
    await _logDebug('Método: GET');
    await _logDebug('Headers: ${_dio.options.headers}');
    
    try {
      final resposta = await _dio.get<List<dynamic>>(_base);
      
      await _logDebug('=== LISTAR OCORRÊNCIAS - RESPOSTA ===');
      await _logDebug('Status Code: ${resposta.statusCode}');
      
      final lista = resposta.data ?? [];
      return lista
          .map((e) => OcorrenciaModelo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      await _logDebug('=== LISTAR OCORRÊNCIAS - ERRO ===');
      await _logDebug('Erro: $e');
      if (e is DioException) {
        await _logDebug('Status Code: ${e.response?.statusCode}');
        await _logDebug('Error Body: ${e.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<List<OcorrenciaModelo>> listarProximas({
    required double latitude,
    required double longitude,
    double raioKm = 10,
  }) async {
    final resposta = await _dio.get<List<dynamic>>(
      '/mapa/proximas',
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'km': raioKm,
      },
    );
    final lista = resposta.data ?? [];
    return lista.map((e) {
      final mapa = Map<String, dynamic>.from(e as Map);
      // A função SQL retorna campos em snake_case compatíveis
      if (mapa['criado_em'] != null && mapa['criadoEm'] == null) {
        mapa['titulo'] ??=
            (mapa['tipo_problema'] as String?)?.replaceAll('_', ' ') ?? 'Ocorrência';
      }
      return OcorrenciaModelo.fromJson(mapa);
    }).toList();
  }

  @override
  Future<OcorrenciaModelo> obterPorId(String id) async {
    final resposta =
        await _dio.get<Map<String, dynamic>>('$_base/$id');
    return OcorrenciaModelo.fromJson(resposta.data!);
  }

  @override
  Future<OcorrenciaModelo> criar(OcorrenciaModelo modelo) async {
    final body = modelo.toCriarJson();
    
    await _logDebug('=== REGISTRO DE OCORRÊNCIA - REQUEST ===');
    await _logDebug('URL: ${_dio.options.baseUrl}$_base');
    await _logDebug('Método: POST');
    await _logDebug('Headers: ${_dio.options.headers}');
    await _logDebug('Body: $body');
    
    // Extract and decode Authorization header for JWT analysis
    final authHeader = _dio.options.headers['Authorization'] as String?;
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      final token = authHeader.substring(7);
      final payload = _decodeJwtPayload(token);
      if (payload != null) {
        final iat = payload['iat'];
        final exp = payload['exp'];
        await _logDebug('JWT Payload: $payload');
        if (iat != null) {
          final iatDate = DateTime.fromMillisecondsSinceEpoch(iat * 1000);
          await _logDebug('JWT iat (emitido em): $iatDate');
        }
        if (exp != null) {
          final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
          await _logDebug('JWT exp (expira em): $expDate');
          await _logDebug('JWT expirado? ${DateTime.now().isAfter(expDate)}');
        }
      }
    }
    
    try {
      final resposta = await _dio.post<Map<String, dynamic>>(
        _base,
        data: body,
      );
      
      await _logDebug('=== REGISTRO DE OCORRÊNCIA - RESPOSTA ===');
      await _logDebug('Status Code: ${resposta.statusCode}');
      await _logDebug('Response Body: ${resposta.data}');
      
      return OcorrenciaModelo.fromJson(resposta.data!);
    } catch (e) {
      await _logDebug('=== REGISTRO DE OCORRÊNCIA - ERRO ===');
      await _logDebug('Erro: $e');
      if (e is DioException) {
        await _logDebug('Status Code: ${e.response?.statusCode}');
        await _logDebug('Error Body: ${e.response?.data}');
        await _logDebug('Response Headers: ${e.response?.headers}');
      }
      rethrow;
    }
  }

  @override
  Future<OcorrenciaModelo> atualizarStatus({
    required String id,
    required String status,
    String? observacao,
  }) async {
    final resposta = await _dio.patch<Map<String, dynamic>>(
      '$_base/$id/status',
      data: {
        'status': status,
        'observacao': ?observacao,
      },
    );
    return OcorrenciaModelo.fromJson(resposta.data!);
  }

  /// Envia imagem como multipart/form-data e retorna a URL pública.
  Future<String> enviarImagem({
    required String ocorrenciaId,
    required File arquivo,
  }) async {
    final nome = arquivo.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'imagem': await MultipartFile.fromFile(
        arquivo.path,
        filename: nome,
      ),
    });
    final resposta = await _dio.post<Map<String, dynamic>>(
      '$_base/$ocorrenciaId/imagens',
      data: formData,
    );
    return resposta.data!['url_imagem'] as String;
  }
}
