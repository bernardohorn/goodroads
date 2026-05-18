// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'documento_consulta_modelo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DocumentoConsultaModelo _$DocumentoConsultaModeloFromJson(
  Map<String, dynamic> json,
) {
  return _DocumentoConsultaModelo.fromJson(json);
}

/// @nodoc
mixin _$DocumentoConsultaModelo {
  String get documento => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;
  String? get nome => throw _privateConstructorUsedError;
  String? get razaoSocial => throw _privateConstructorUsedError;
  String? get situacao => throw _privateConstructorUsedError;

  /// Serializes this DocumentoConsultaModelo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentoConsultaModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentoConsultaModeloCopyWith<DocumentoConsultaModelo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentoConsultaModeloCopyWith<$Res> {
  factory $DocumentoConsultaModeloCopyWith(
    DocumentoConsultaModelo value,
    $Res Function(DocumentoConsultaModelo) then,
  ) = _$DocumentoConsultaModeloCopyWithImpl<$Res, DocumentoConsultaModelo>;
  @useResult
  $Res call({
    String documento,
    String tipo,
    String? nome,
    String? razaoSocial,
    String? situacao,
  });
}

/// @nodoc
class _$DocumentoConsultaModeloCopyWithImpl<
  $Res,
  $Val extends DocumentoConsultaModelo
>
    implements $DocumentoConsultaModeloCopyWith<$Res> {
  _$DocumentoConsultaModeloCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentoConsultaModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documento = null,
    Object? tipo = null,
    Object? nome = freezed,
    Object? razaoSocial = freezed,
    Object? situacao = freezed,
  }) {
    return _then(
      _value.copyWith(
            documento: null == documento
                ? _value.documento
                : documento // ignore: cast_nullable_to_non_nullable
                      as String,
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as String,
            nome: freezed == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String?,
            razaoSocial: freezed == razaoSocial
                ? _value.razaoSocial
                : razaoSocial // ignore: cast_nullable_to_non_nullable
                      as String?,
            situacao: freezed == situacao
                ? _value.situacao
                : situacao // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DocumentoConsultaModeloImplCopyWith<$Res>
    implements $DocumentoConsultaModeloCopyWith<$Res> {
  factory _$$DocumentoConsultaModeloImplCopyWith(
    _$DocumentoConsultaModeloImpl value,
    $Res Function(_$DocumentoConsultaModeloImpl) then,
  ) = __$$DocumentoConsultaModeloImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String documento,
    String tipo,
    String? nome,
    String? razaoSocial,
    String? situacao,
  });
}

/// @nodoc
class __$$DocumentoConsultaModeloImplCopyWithImpl<$Res>
    extends
        _$DocumentoConsultaModeloCopyWithImpl<
          $Res,
          _$DocumentoConsultaModeloImpl
        >
    implements _$$DocumentoConsultaModeloImplCopyWith<$Res> {
  __$$DocumentoConsultaModeloImplCopyWithImpl(
    _$DocumentoConsultaModeloImpl _value,
    $Res Function(_$DocumentoConsultaModeloImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentoConsultaModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documento = null,
    Object? tipo = null,
    Object? nome = freezed,
    Object? razaoSocial = freezed,
    Object? situacao = freezed,
  }) {
    return _then(
      _$DocumentoConsultaModeloImpl(
        documento: null == documento
            ? _value.documento
            : documento // ignore: cast_nullable_to_non_nullable
                  as String,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: freezed == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String?,
        razaoSocial: freezed == razaoSocial
            ? _value.razaoSocial
            : razaoSocial // ignore: cast_nullable_to_non_nullable
                  as String?,
        situacao: freezed == situacao
            ? _value.situacao
            : situacao // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentoConsultaModeloImpl implements _DocumentoConsultaModelo {
  const _$DocumentoConsultaModeloImpl({
    required this.documento,
    required this.tipo,
    this.nome,
    this.razaoSocial,
    this.situacao,
  });

  factory _$DocumentoConsultaModeloImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentoConsultaModeloImplFromJson(json);

  @override
  final String documento;
  @override
  final String tipo;
  @override
  final String? nome;
  @override
  final String? razaoSocial;
  @override
  final String? situacao;

  @override
  String toString() {
    return 'DocumentoConsultaModelo(documento: $documento, tipo: $tipo, nome: $nome, razaoSocial: $razaoSocial, situacao: $situacao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentoConsultaModeloImpl &&
            (identical(other.documento, documento) ||
                other.documento == documento) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.razaoSocial, razaoSocial) ||
                other.razaoSocial == razaoSocial) &&
            (identical(other.situacao, situacao) ||
                other.situacao == situacao));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, documento, tipo, nome, razaoSocial, situacao);

  /// Create a copy of DocumentoConsultaModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentoConsultaModeloImplCopyWith<_$DocumentoConsultaModeloImpl>
  get copyWith =>
      __$$DocumentoConsultaModeloImplCopyWithImpl<
        _$DocumentoConsultaModeloImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentoConsultaModeloImplToJson(this);
  }
}

abstract class _DocumentoConsultaModelo implements DocumentoConsultaModelo {
  const factory _DocumentoConsultaModelo({
    required final String documento,
    required final String tipo,
    final String? nome,
    final String? razaoSocial,
    final String? situacao,
  }) = _$DocumentoConsultaModeloImpl;

  factory _DocumentoConsultaModelo.fromJson(Map<String, dynamic> json) =
      _$DocumentoConsultaModeloImpl.fromJson;

  @override
  String get documento;
  @override
  String get tipo;
  @override
  String? get nome;
  @override
  String? get razaoSocial;
  @override
  String? get situacao;

  /// Create a copy of DocumentoConsultaModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentoConsultaModeloImplCopyWith<_$DocumentoConsultaModeloImpl>
  get copyWith => throw _privateConstructorUsedError;
}
