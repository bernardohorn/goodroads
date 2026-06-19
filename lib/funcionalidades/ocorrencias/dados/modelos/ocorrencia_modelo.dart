import 'package:freezed_annotation/freezed_annotation.dart';

import '../../dominio/entidades/ocorrencia_entidade.dart';

part 'ocorrencia_modelo.freezed.dart';
part 'ocorrencia_modelo.g.dart';

/// Modelo de dados de ocorrência.
@freezed
class OcorrenciaModelo with _$OcorrenciaModelo {
  const factory OcorrenciaModelo({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String titulo,
    required String descricao,
    required double latitude,
    required double longitude,
    required String status,
    @JsonKey(name: 'criado_em') required DateTime criadoEm,
    @JsonKey(name: 'imagens_urls') @Default([]) List<String> imagensUrls,
    @JsonKey(name: 'tipo_problema') String? tipoProblema,
    String? urgencia,
    String? municipio,
    String? protocolo,
    @JsonKey(name: 'usuario_id', fromJson: _idOpcionalFromJson)
    String? usuarioId,
    @Default([]) List<HistoricoStatusModelo> historico,
  }) = _OcorrenciaModelo;

  const OcorrenciaModelo._();

  factory OcorrenciaModelo.fromJson(Map<String, dynamic> json) =>
      _$OcorrenciaModeloFromJson(json);

  OcorrenciaEntidade toEntidade() => OcorrenciaEntidade(
        id: id,
        titulo: titulo,
        descricao: descricao,
        latitude: latitude,
        longitude: longitude,
        status: status,
        criadoEm: criadoEm,
        imagensUrls: imagensUrls,
        tipoProblema: tipoProblema,
        urgencia: urgencia,
        municipio: municipio,
        protocolo: protocolo,
        usuarioId: usuarioId,
        historico: historico.map((h) => h.toEntidade()).toList(),
      );

  /// Payload para POST /api/ocorrencias.
  Map<String, dynamic> toCriarJson() => {
        'descricao': descricao,
        'latitude': latitude,
        'longitude': longitude,
        'tipo_problema': tipoProblema ?? 'outro',
        'urgencia': urgencia ?? 'media',
        if (municipio != null) 'municipio': municipio,
      };
}

@freezed
class HistoricoStatusModelo with _$HistoricoStatusModelo {
  const factory HistoricoStatusModelo({
    required String status,
    @JsonKey(name: 'data_alteracao') required DateTime dataAlteracao,
    String? observacao,
    String? responsavel,
  }) = _HistoricoStatusModelo;

  const HistoricoStatusModelo._();

  factory HistoricoStatusModelo.fromJson(Map<String, dynamic> json) =>
      _$HistoricoStatusModeloFromJson(json);

  HistoricoStatusEntidade toEntidade() => HistoricoStatusEntidade(
        status: status,
        dataAlteracao: dataAlteracao,
        observacao: observacao,
        responsavel: responsavel,
      );
}

String _idFromJson(Object? valor) => valor?.toString() ?? '';

String? _idOpcionalFromJson(Object? valor) => valor?.toString();
