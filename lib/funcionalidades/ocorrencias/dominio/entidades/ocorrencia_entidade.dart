/// Entidade de ocorrência em estrada rural.
class OcorrenciaEntidade {
  const OcorrenciaEntidade({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.criadoEm,
    this.imagensUrls = const [],
  });

  final String id;
  final String titulo;
  final String descricao;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime criadoEm;
  final List<String> imagensUrls;
}
