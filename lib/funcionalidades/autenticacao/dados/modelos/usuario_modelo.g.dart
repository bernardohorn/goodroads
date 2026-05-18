// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsuarioModeloImpl _$$UsuarioModeloImplFromJson(Map<String, dynamic> json) =>
    _$UsuarioModeloImpl(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      fotoUrl: json['foto_url'] as String?,
      papel: json['papel'] as String?,
    );

Map<String, dynamic> _$$UsuarioModeloImplToJson(_$UsuarioModeloImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'email': instance.email,
      if (instance.fotoUrl case final value?) 'foto_url': value,
      if (instance.papel case final value?) 'papel': value,
    };
