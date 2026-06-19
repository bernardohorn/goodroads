import 'package:freezed_annotation/freezed_annotation.dart';

import '../../dominio/entidades/usuario_entidade.dart';

part 'usuario_modelo.freezed.dart';
part 'usuario_modelo.g.dart';

/// Modelo de dados do usuário (API/Firebase).
@freezed
class UsuarioModelo with _$UsuarioModelo {
  const factory UsuarioModelo({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String nome,
    required String email,
    @JsonKey(name: 'foto_url') String? fotoUrl,
    @JsonKey(name: 'tipo') String? papel,
  }) = _UsuarioModelo;

  const UsuarioModelo._();

  factory UsuarioModelo.fromJson(Map<String, dynamic> json) =>
      _$UsuarioModeloFromJson(json);

  UsuarioEntidade toEntidade() => UsuarioEntidade(
        id: id,
        nome: nome,
        email: email,
        fotoUrl: fotoUrl,
        papel: papel,
      );

  factory UsuarioModelo.fromEntidade(UsuarioEntidade entidade) {
    return UsuarioModelo(
      id: entidade.id,
      nome: entidade.nome,
      email: entidade.email,
      fotoUrl: entidade.fotoUrl,
      papel: entidade.papel,
    );
  }
}

String _idFromJson(Object? valor) => valor?.toString() ?? '';
