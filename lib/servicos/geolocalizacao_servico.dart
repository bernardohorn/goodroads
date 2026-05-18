import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Serviço de geolocalização para mapas e ocorrências.
abstract interface class GeolocalizacaoServico {
  Future<({double latitude, double longitude})?> obterPosicaoAtual();

  Future<bool> solicitarPermissao();
}

class GeolocalizacaoServicoImpl implements GeolocalizacaoServico {
  @override
  Future<bool> solicitarPermissao() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) return true;

    final servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) return false;

    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    return permissao == LocationPermission.always ||
        permissao == LocationPermission.whileInUse;
  }

  @override
  Future<({double latitude, double longitude})?> obterPosicaoAtual() async {
    final temPermissao = await solicitarPermissao();
    if (!temPermissao) return null;

    final posicao = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return (latitude: posicao.latitude, longitude: posicao.longitude);
  }
}
