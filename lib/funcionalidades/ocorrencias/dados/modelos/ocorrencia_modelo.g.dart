// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocorrencia_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OcorrenciaModeloImpl _$$OcorrenciaModeloImplFromJson(
  Map<String, dynamic> json,
) => _$OcorrenciaModeloImpl(
  id: json['id'] as String,
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
};
