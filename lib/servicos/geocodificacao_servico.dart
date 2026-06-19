import 'package:dio/dio.dart';

import '../configuracao/ambiente/variaveis_ambiente.dart';

/// Resultado de geocodificação reversa.
class EnderecoGeocodificado {
  const EnderecoGeocodificado({
    required this.enderecoFormatado,
    this.municipio,
  });

  final String enderecoFormatado;
  final String? municipio;
}

/// Serviço de geocodificação reversa via Google Maps Geocoding API.
abstract interface class GeocodificacaoServico {
  Future<EnderecoGeocodificado?> geocodificarReversa({
    required double latitude,
    required double longitude,
  });
}

class GeocodificacaoServicoImpl implements GeocodificacaoServico {
  GeocodificacaoServicoImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<EnderecoGeocodificado?> geocodificarReversa({
    required double latitude,
    required double longitude,
  }) async {
    final chave = VariaveisAmbiente.googleMapsApiKey;
    if (chave.isEmpty) return null;

    try {
      final resposta = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '$latitude,$longitude',
          'key': chave,
          'language': 'pt-BR',
        },
      );

      final resultados = resposta.data?['results'] as List<dynamic>?;
      if (resultados == null || resultados.isEmpty) return null;

      final primeiro = resultados.first as Map<String, dynamic>;
      final endereco = primeiro['formatted_address'] as String? ?? '';
      String? municipio;

      final componentes = primeiro['address_components'] as List<dynamic>?;
      if (componentes != null) {
        for (final comp in componentes) {
          final mapa = comp as Map<String, dynamic>;
          final tipos = (mapa['types'] as List<dynamic>).cast<String>();
          if (tipos.contains('administrative_area_level_2') ||
              tipos.contains('locality')) {
            municipio = mapa['long_name'] as String?;
            break;
          }
        }
      }

      return EnderecoGeocodificado(
        enderecoFormatado: endereco,
        municipio: municipio,
      );
    } catch (_) {
      return null;
    }
  }
}
