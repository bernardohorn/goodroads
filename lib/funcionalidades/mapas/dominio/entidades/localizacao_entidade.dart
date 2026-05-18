/// Entidade de localização geográfica.
class LocalizacaoEntidade {
  const LocalizacaoEntidade({
    required this.latitude,
    required this.longitude,
    this.endereco,
  });

  final double latitude;
  final double longitude;
  final String? endereco;
}
