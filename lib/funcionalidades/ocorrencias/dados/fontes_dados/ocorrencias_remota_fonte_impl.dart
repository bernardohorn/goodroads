import 'package:dio/dio.dart';
import 'dart:io';

import '../modelos/ocorrencia_modelo.dart';
import 'ocorrencias_remota_fonte.dart';

/// Fonte remota de ocorrências conectada à API REST do GoodRoads.
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
    final resposta = await _dio.post<Map<String, dynamic>>(
      _base,
      data: modelo.toCriarJson(),
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
