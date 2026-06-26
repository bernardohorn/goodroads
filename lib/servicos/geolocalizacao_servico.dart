import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Serviço de geolocalização para mapas e ocorrências.
abstract interface class GeolocalizacaoServico {
  /// Obtém a posição atual do dispositivo.
  /// Retorna `null` se permissão negada, GPS desligado, ou timeout.
  Future<({double latitude, double longitude})?> obterPosicaoAtual();

  /// Solicita permissão de localização ao usuário.
  /// Retorna `true` se a permissão foi concedida.
  Future<bool> solicitarPermissao();

  /// Abre as configurações do app (útil quando permissão negada permanentemente).
  Future<bool> abrirConfiguracoes();

  /// Stream de atualizações de posição em tempo real.
  /// Cancele a subscrição no `dispose()` para evitar memory leak.
  Stream<({double latitude, double longitude})> streamPosicao();
}

class GeolocalizacaoServicoImpl implements GeolocalizacaoServico {
  @override
  Future<bool> abrirConfiguracoes() => openAppSettings();

  @override
  Future<bool> solicitarPermissao() async {
    try {
      final servicoHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicoHabilitado) {
        debugPrint('[GoodRoads] GPS desligado no dispositivo.');
        return false;
      }

      final statusPermissao = await Permission.locationWhenInUse.request();
      if (statusPermissao.isGranted) return true;
      if (statusPermissao.isPermanentlyDenied) {
        debugPrint(
          '[GoodRoads] Permissão de localização permanentemente negada. '
          'Usuário deve habilitar nas configurações do sistema.',
        );
        return false;
      }

      var permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      return permissao == LocationPermission.always ||
          permissao == LocationPermission.whileInUse;
    } catch (e) {
      debugPrint('[GoodRoads] Erro ao solicitar permissão de localização: $e');
      return false;
    }
  }

  @override
  Future<({double latitude, double longitude})?> obterPosicaoAtual() async {
    try {
      final temPermissao = await solicitarPermissao();
      if (!temPermissao) return null;

      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return (latitude: posicao.latitude, longitude: posicao.longitude);
    } on LocationServiceDisabledException {
      debugPrint('[GoodRoads] GPS desligado ao tentar obter posição.');
      return null;
    } on PermissionDeniedException catch (e) {
      debugPrint('[GoodRoads] Permissão de localização negada: $e');
      return null;
    } catch (e) {
      debugPrint('[GoodRoads] Erro ao obter posição atual: $e');
      return null;
    }
  }

  @override
  Stream<({double latitude, double longitude})> streamPosicao() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).map((p) => (latitude: p.latitude, longitude: p.longitude));
  }
}
