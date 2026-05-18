// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usuario_modelo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UsuarioModelo _$UsuarioModeloFromJson(Map<String, dynamic> json) {
  return _UsuarioModelo.fromJson(json);
}

/// @nodoc
mixin _$UsuarioModelo {
  String get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get fotoUrl => throw _privateConstructorUsedError;
  String? get papel => throw _privateConstructorUsedError;

  /// Serializes this UsuarioModelo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsuarioModeloCopyWith<UsuarioModelo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsuarioModeloCopyWith<$Res> {
  factory $UsuarioModeloCopyWith(
    UsuarioModelo value,
    $Res Function(UsuarioModelo) then,
  ) = _$UsuarioModeloCopyWithImpl<$Res, UsuarioModelo>;
  @useResult
  $Res call({
    String id,
    String nome,
    String email,
    String? fotoUrl,
    String? papel,
  });
}

/// @nodoc
class _$UsuarioModeloCopyWithImpl<$Res, $Val extends UsuarioModelo>
    implements $UsuarioModeloCopyWith<$Res> {
  _$UsuarioModeloCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? email = null,
    Object? fotoUrl = freezed,
    Object? papel = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nome: null == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            fotoUrl: freezed == fotoUrl
                ? _value.fotoUrl
                : fotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            papel: freezed == papel
                ? _value.papel
                : papel // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsuarioModeloImplCopyWith<$Res>
    implements $UsuarioModeloCopyWith<$Res> {
  factory _$$UsuarioModeloImplCopyWith(
    _$UsuarioModeloImpl value,
    $Res Function(_$UsuarioModeloImpl) then,
  ) = __$$UsuarioModeloImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nome,
    String email,
    String? fotoUrl,
    String? papel,
  });
}

/// @nodoc
class __$$UsuarioModeloImplCopyWithImpl<$Res>
    extends _$UsuarioModeloCopyWithImpl<$Res, _$UsuarioModeloImpl>
    implements _$$UsuarioModeloImplCopyWith<$Res> {
  __$$UsuarioModeloImplCopyWithImpl(
    _$UsuarioModeloImpl _value,
    $Res Function(_$UsuarioModeloImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? email = null,
    Object? fotoUrl = freezed,
    Object? papel = freezed,
  }) {
    return _then(
      _$UsuarioModeloImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        fotoUrl: freezed == fotoUrl
            ? _value.fotoUrl
            : fotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        papel: freezed == papel
            ? _value.papel
            : papel // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsuarioModeloImpl extends _UsuarioModelo {
  const _$UsuarioModeloImpl({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoUrl,
    this.papel,
  }) : super._();

  factory _$UsuarioModeloImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsuarioModeloImplFromJson(json);

  @override
  final String id;
  @override
  final String nome;
  @override
  final String email;
  @override
  final String? fotoUrl;
  @override
  final String? papel;

  @override
  String toString() {
    return 'UsuarioModelo(id: $id, nome: $nome, email: $email, fotoUrl: $fotoUrl, papel: $papel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsuarioModeloImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl) &&
            (identical(other.papel, papel) || other.papel == papel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nome, email, fotoUrl, papel);

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsuarioModeloImplCopyWith<_$UsuarioModeloImpl> get copyWith =>
      __$$UsuarioModeloImplCopyWithImpl<_$UsuarioModeloImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsuarioModeloImplToJson(this);
  }
}

abstract class _UsuarioModelo extends UsuarioModelo {
  const factory _UsuarioModelo({
    required final String id,
    required final String nome,
    required final String email,
    final String? fotoUrl,
    final String? papel,
  }) = _$UsuarioModeloImpl;
  const _UsuarioModelo._() : super._();

  factory _UsuarioModelo.fromJson(Map<String, dynamic> json) =
      _$UsuarioModeloImpl.fromJson;

  @override
  String get id;
  @override
  String get nome;
  @override
  String get email;
  @override
  String? get fotoUrl;
  @override
  String? get papel;

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsuarioModeloImplCopyWith<_$UsuarioModeloImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
