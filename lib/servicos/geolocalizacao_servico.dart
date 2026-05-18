/// Contrato para geolocalização e mapas (implementação futura).
abstract interface class GeolocalizacaoServico {
  Future<({double latitude, double longitude})?> obterPosicaoAtual();

  Future<bool> solicitarPermissao();
}
