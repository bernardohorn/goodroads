import '../../dominio/entidades/ocorrencia_entidade.dart';

/// Modelo de dados de ocorrência.
class OcorrenciaModelo {
  const OcorrenciaModelo({
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

  OcorrenciaEntidade toEntidade() => OcorrenciaEntidade(
        id: id,
        titulo: titulo,
        descricao: descricao,
        latitude: latitude,
        longitude: longitude,
        status: status,
        criadoEm: criadoEm,
        imagensUrls: imagensUrls,
      );
}
