/// Entrada do histórico de status de uma ocorrência.
class HistoricoStatusEntidade {
  const HistoricoStatusEntidade({
    required this.status,
    required this.dataAlteracao,
    this.observacao,
    this.responsavel,
  });

  final String status;
  final DateTime dataAlteracao;
  final String? observacao;
  final String? responsavel;
}

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
    this.tipoProblema,
    this.urgencia,
    this.municipio,
    this.protocolo,
    this.usuarioId,
    this.historico = const [],
  });

  final String id;
  final String titulo;
  final String descricao;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime criadoEm;
  final List<String> imagensUrls;
  final String? tipoProblema;
  final String? urgencia;
  final String? municipio;
  final String? protocolo;
  final String? usuarioId;
  final List<HistoricoStatusEntidade> historico;
}
