// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocorrencia_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OcorrenciaModeloImpl _$$OcorrenciaModeloImplFromJson(
  Map<String, dynamic> json,
) => _$OcorrenciaModeloImpl(
  id: _idFromJson(json['id']),
  titulo: json['titulo'] as String,
  descricao: json['descricao'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  status: json['status'] as String,
  criadoEm: DateTime.parse(json['criado_em'] as String),
  imagensUrls:
      (json['imagens_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  tipoProblema: json['tipo_problema'] as String?,
  urgencia: json['urgencia'] as String?,
  municipio: json['municipio'] as String?,
  protocolo: json['protocolo'] as String?,
  usuarioId: _idOpcionalFromJson(json['usuario_id']),
  historico:
      (json['historico'] as List<dynamic>?)
          ?.map(
            (e) => HistoricoStatusModelo.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OcorrenciaModeloImplToJson(
  _$OcorrenciaModeloImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'titulo': instance.titulo,
  'descricao': instance.descricao,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'status': instance.status,
  'criado_em': instance.criadoEm.toIso8601String(),
  'imagens_urls': instance.imagensUrls,
  if (instance.tipoProblema case final value?) 'tipo_problema': value,
  if (instance.urgencia case final value?) 'urgencia': value,
  if (instance.municipio case final value?) 'municipio': value,
  if (instance.protocolo case final value?) 'protocolo': value,
  if (instance.usuarioId case final value?) 'usuario_id': value,
  'historico': instance.historico.map((e) => e.toJson()).toList(),
};

_$HistoricoStatusModeloImpl _$$HistoricoStatusModeloImplFromJson(
  Map<String, dynamic> json,
) => _$HistoricoStatusModeloImpl(
  status: json['status'] as String,
  dataAlteracao: DateTime.parse(json['data_alteracao'] as String),
  observacao: json['observacao'] as String?,
  responsavel: json['responsavel'] as String?,
);

Map<String, dynamic> _$$HistoricoStatusModeloImplToJson(
  _$HistoricoStatusModeloImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'data_alteracao': instance.dataAlteracao.toIso8601String(),
  if (instance.observacao case final value?) 'observacao': value,
  if (instance.responsavel case final value?) 'responsavel': value,
};
