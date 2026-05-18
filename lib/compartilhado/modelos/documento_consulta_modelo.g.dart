// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documento_consulta_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentoConsultaModeloImpl _$$DocumentoConsultaModeloImplFromJson(
  Map<String, dynamic> json,
) => _$DocumentoConsultaModeloImpl(
  documento: json['documento'] as String,
  tipo: json['tipo'] as String,
  nome: json['nome'] as String?,
  razaoSocial: json['razao_social'] as String?,
  situacao: json['situacao'] as String?,
);

Map<String, dynamic> _$$DocumentoConsultaModeloImplToJson(
  _$DocumentoConsultaModeloImpl instance,
) => <String, dynamic>{
  'documento': instance.documento,
  'tipo': instance.tipo,
  if (instance.nome case final value?) 'nome': value,
  if (instance.razaoSocial case final value?) 'razao_social': value,
  if (instance.situacao case final value?) 'situacao': value,
};
