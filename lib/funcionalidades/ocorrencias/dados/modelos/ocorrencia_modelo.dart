import 'package:freezed_annotation/freezed_annotation.dart';

import '../../dominio/entidades/ocorrencia_entidade.dart';

part 'ocorrencia_modelo.freezed.dart';
part 'ocorrencia_modelo.g.dart';

/// Modelo de dados de ocorrência.
@freezed
class OcorrenciaModelo with _$OcorrenciaModelo {
  const factory OcorrenciaModelo({
    required String id,
    required String titulo,
    required String descricao,
    required double latitude,
    required double longitude,
    required String status,
    required DateTime criadoEm,
    @Default([]) List<String> imagensUrls,
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
      );
}
