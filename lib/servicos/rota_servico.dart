import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../configuracao/ambiente/variaveis_ambiente.dart';

/// Resultado de uma rota calculada.
class RotaCalculada {
  const RotaCalculada({
    required this.pontos,
    required this.distanciaMetros,
    required this.duracaoSegundos,
    required this.resumo,
  });

  /// Lista de coordenadas que formam a polyline da rota.
  final List<LatLng> pontos;

  /// Distância total em metros.
  final int distanciaMetros;

  /// Duração estimada em segundos.
  final int duracaoSegundos;

  /// Texto resumido da rota (ex: "Rodovia BR-101").
  final String resumo;

  /// Distância formatada para exibição (ex: "5,2 km").
  String get distanciaFormatada {
    if (distanciaMetros >= 1000) {
      return '${(distanciaMetros / 1000).toStringAsFixed(1).replaceAll('.', ',')} km';
    }
    return '$distanciaMetros m';
  }

  /// Duração formatada para exibição (ex: "12 min").
  String get duracaoFormatada {
    final minutos = (duracaoSegundos / 60).round();
    if (minutos >= 60) {
      final horas = minutos ~/ 60;
      final min = minutos % 60;
      return '$horas h ${min.toString().padLeft(2, '0')} min';
    }
    return '$minutos min';
  }
}

/// Serviço de cálculo de rotas via Google Directions API.
abstract interface class RotaServico {
  /// Calcula a rota entre [origem] e [destino].
  /// Retorna `null` se nenhuma rota for encontrada ou se houver erro.
  Future<RotaCalculada?> calcularRota({
    required LatLng origem,
    required LatLng destino,
  });
}

class RotaServicoImpl implements RotaServico {
  RotaServicoImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  // Cache da última rota para evitar requisições redundantes
  LatLng? _ultimaOrigem;
  LatLng? _ultimoDestino;
  RotaCalculada? _cacheRota;

  @override
  Future<RotaCalculada?> calcularRota({
    required LatLng origem,
    required LatLng destino,
  }) async {
    final chave = VariaveisAmbiente.googleMapsApiKey;
    if (chave.isEmpty) {
      debugPrint(
        '[GoodRoads] RotaServico: GOOGLE_MAPS_API_KEY não configurada. '
        'Defina no .env para habilitar roteamento.',
      );
      return null;
    }

    // Retorna cache se origem e destino forem os mesmos
    if (_cacheValido(origem, destino)) {
      return _cacheRota;
    }

    try {
      final resposta = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '${origem.latitude},${origem.longitude}',
          'destination': '${destino.latitude},${destino.longitude}',
          'key': chave,
          'language': 'pt-BR',
          'mode': 'driving',
        },
      );

      final dados = resposta.data;
      if (dados == null) {
        debugPrint('[GoodRoads] RotaServico: resposta vazia da API.');
        return null;
      }

      final status = dados['status'] as String?;
      if (status != 'OK') {
        debugPrint(
          '[GoodRoads] RotaServico: status da API = $status. '
          'Verifique se a Directions API está habilitada no Google Cloud Console.',
        );
        return null;
      }

      final rotas = dados['routes'] as List<dynamic>?;
      if (rotas == null || rotas.isEmpty) {
        debugPrint('[GoodRoads] RotaServico: nenhuma rota encontrada.');
        return null;
      }

      final rota = rotas.first as Map<String, dynamic>;
      final legs = (rota['legs'] as List<dynamic>?)?.first as Map<String, dynamic>?;
      if (legs == null) return null;

      final distancia = (legs['distance'] as Map<String, dynamic>?)?['value'] as int? ?? 0;
      final duracao = (legs['duration'] as Map<String, dynamic>?)?['value'] as int? ?? 0;
      final resumo = rota['summary'] as String? ?? '';

      // Decodifica polyline comprimida
      final polylineEncoded =
          (rota['overview_polyline'] as Map<String, dynamic>?)?['points'] as String?;
      if (polylineEncoded == null) return null;

      final pontos = _decodificarPolyline(polylineEncoded);

      final resultado = RotaCalculada(
        pontos: pontos,
        distanciaMetros: distancia,
        duracaoSegundos: duracao,
        resumo: resumo,
      );

      // Salva no cache
      _ultimaOrigem = origem;
      _ultimoDestino = destino;
      _cacheRota = resultado;

      debugPrint(
        '[GoodRoads] RotaServico: rota calculada — '
        '${resultado.distanciaFormatada}, ${resultado.duracaoFormatada}.',
      );

      return resultado;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        debugPrint('[GoodRoads] RotaServico: sem conexão com a internet.');
      } else {
        debugPrint('[GoodRoads] RotaServico: erro HTTP ${e.response?.statusCode} — ${e.message}');
      }
      return null;
    } catch (e) {
      debugPrint('[GoodRoads] RotaServico: erro inesperado — $e');
      return null;
    }
  }

  /// Verifica se o cache ainda é válido para a mesma origem e destino.
  bool _cacheValido(LatLng origem, LatLng destino) {
    if (_ultimaOrigem == null || _ultimoDestino == null || _cacheRota == null) {
      return false;
    }
    const tolerancia = 0.0001; // ~11 metros
    return (_ultimaOrigem!.latitude - origem.latitude).abs() < tolerancia &&
        (_ultimaOrigem!.longitude - origem.longitude).abs() < tolerancia &&
        (_ultimoDestino!.latitude - destino.latitude).abs() < tolerancia &&
        (_ultimoDestino!.longitude - destino.longitude).abs() < tolerancia;
  }

  /// Decodifica o formato Encoded Polyline Algorithm do Google Maps.
  List<LatLng> _decodificarPolyline(String encoded) {
    final pontos = <LatLng>[];
    int index = 0;
    final comprimento = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < comprimento) {
      int b;
      int deslocamento = 0;
      int resultado = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        resultado |= (b & 0x1F) << deslocamento;
        deslocamento += 5;
      } while (b >= 0x20);

      final deltaLat = (resultado & 1) != 0 ? ~(resultado >> 1) : (resultado >> 1);
      lat += deltaLat;

      deslocamento = 0;
      resultado = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        resultado |= (b & 0x1F) << deslocamento;
        deslocamento += 5;
      } while (b >= 0x20);

      final deltaLng = (resultado & 1) != 0 ? ~(resultado >> 1) : (resultado >> 1);
      lng += deltaLng;

      pontos.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return pontos;
  }
}
