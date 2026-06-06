import 'package:dio/dio.dart';
import 'dart:io';

import '../modelos/ocorrencia_modelo.dart';

/// Fonte remota de ocorrências conectada à API REST do GoodRoads.
abstract interface class OcorrenciasRemotaFonte {
  Future<List<OcorrenciaModelo>> listar();
  Future<OcorrenciaModelo> obterPorId(String id);
  Future<OcorrenciaModelo> criar(OcorrenciaModelo modelo);
  Future<OcorrenciaModelo> atualizarStatus({
    required String id,
    required String status,
    String? observacao,
  });
}

class OcorrenciasRemotaFonteImpl implements OcorrenciasRemotaFonte {
  OcorrenciasRemotaFonteImpl(this._dio);

  final Dio _dio;

  static const String _base = '/ocorrencias';

  @override
  Future<List<OcorrenciaModelo>> listar() async {
    final resposta = await _dio.get<List<dynamic>>(_base);
    final lista = resposta.data ?? [];
    return lista
        .map((e) => OcorrenciaModelo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OcorrenciaModelo> obterPorId(String id) async {
    final resposta =
        await _dio.get<Map<String, dynamic>>('$_base/$id');
    return OcorrenciaModelo.fromJson(resposta.data!);
  }

  @override
  Future<OcorrenciaModelo> criar(OcorrenciaModelo modelo) async {
    final resposta = await _dio.post<Map<String, dynamic>>(
      _base,
      data: modelo.toJson(),
    );
    return OcorrenciaModelo.fromJson(resposta.data!);
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
        if (observacao != null) 'observacao': observacao,
      },
    );
    return OcorrenciaModelo.fromJson(resposta.data!);
  }

  /// Envia imagem como multipart/form-data e retorna a URL pública.
  Future<String> enviarImagem({
    required String ocorrenciaId,
    required File arquivo,
  }) async {
    final nome = arquivo.path.split('/').last;
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