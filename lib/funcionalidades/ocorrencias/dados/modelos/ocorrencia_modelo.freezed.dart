// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocorrencia_modelo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OcorrenciaModelo _$OcorrenciaModeloFromJson(Map<String, dynamic> json) {
  return _OcorrenciaModelo.fromJson(json);
}

/// @nodoc
mixin _$OcorrenciaModelo {
  String get id => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get criadoEm => throw _privateConstructorUsedError;
  List<String> get imagensUrls => throw _privateConstructorUsedError;

  /// Serializes this OcorrenciaModelo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OcorrenciaModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OcorrenciaModeloCopyWith<OcorrenciaModelo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OcorrenciaModeloCopyWith<$Res> {
  factory $OcorrenciaModeloCopyWith(
    OcorrenciaModelo value,
    $Res Function(OcorrenciaModelo) then,
  ) = _$OcorrenciaModeloCopyWithImpl<$Res, OcorrenciaModelo>;
  @useResult
  $Res call({
    String id,
    String titulo,
    String descricao,
    double latitude,
    double longitude,
    String status,
    DateTime criadoEm,
    List<String> imagensUrls,
  });
}

/// @nodoc
class _$OcorrenciaModeloCopyWithImpl<$Res, $Val extends OcorrenciaModelo>
    implements $OcorrenciaModeloCopyWith<$Res> {
  _$OcorrenciaModeloCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OcorrenciaModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? descricao = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? status = null,
    Object? criadoEm = null,
    Object? imagensUrls = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            titulo: null == titulo
                ? _value.titulo
                : titulo // ignore: cast_nullable_to_non_nullable
                      as String,
            descricao: null == descricao
                ? _value.descricao
                : descricao // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            criadoEm: null == criadoEm
                ? _value.criadoEm
                : criadoEm // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            imagensUrls: null == imagensUrls
                ? _value.imagensUrls
                : imagensUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OcorrenciaModeloImplCopyWith<$Res>
    implements $OcorrenciaModeloCopyWith<$Res> {
  factory _$$OcorrenciaModeloImplCopyWith(
    _$OcorrenciaModeloImpl value,
    $Res Function(_$OcorrenciaModeloImpl) then,
  ) = __$$OcorrenciaModeloImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String titulo,
    String descricao,
    double latitude,
    double longitude,
    String status,
    DateTime criadoEm,
    List<String> imagensUrls,
  });
}

/// @nodoc
class __$$OcorrenciaModeloImplCopyWithImpl<$Res>
    extends _$OcorrenciaModeloCopyWithImpl<$Res, _$OcorrenciaModeloImpl>
    implements _$$OcorrenciaModeloImplCopyWith<$Res> {
  __$$OcorrenciaModeloImplCopyWithImpl(
    _$OcorrenciaModeloImpl _value,
    $Res Function(_$OcorrenciaModeloImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OcorrenciaModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? descricao = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? status = null,
    Object? criadoEm = null,
    Object? imagensUrls = null,
  }) {
    return _then(
      _$OcorrenciaModeloImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        titulo: null == titulo
            ? _value.titulo
            : titulo // ignore: cast_nullable_to_non_nullable
                  as String,
        descricao: null == descricao
            ? _value.descricao
            : descricao // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        criadoEm: null == criadoEm
            ? _value.criadoEm
            : criadoEm // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        imagensUrls: null == imagensUrls
            ? _value._imagensUrls
            : imagensUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OcorrenciaModeloImpl extends _OcorrenciaModelo {
  const _$OcorrenciaModeloImpl({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.criadoEm,
    final List<String> imagensUrls = const [],
  }) : _imagensUrls = imagensUrls,
       super._();

  factory _$OcorrenciaModeloImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcorrenciaModeloImplFromJson(json);

  @override
  final String id;
  @override
  final String titulo;
  @override
  final String descricao;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String status;
  @override
  final DateTime criadoEm;
  final List<String> _imagensUrls;
  @override
  @JsonKey()
  List<String> get imagensUrls {
    if (_imagensUrls is EqualUnmodifiableListView) return _imagensUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imagensUrls);
  }

  @override
  String toString() {
    return 'OcorrenciaModelo(id: $id, titulo: $titulo, descricao: $descricao, latitude: $latitude, longitude: $longitude, status: $status, criadoEm: $criadoEm, imagensUrls: $imagensUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OcorrenciaModeloImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.criadoEm, criadoEm) ||
                other.criadoEm == criadoEm) &&
            const DeepCollectionEquality().equals(
              other._imagensUrls,
              _imagensUrls,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    titulo,
    descricao,
    latitude,
    longitude,
    status,
    criadoEm,
    const DeepCollectionEquality().hash(_imagensUrls),
  );

  /// Create a copy of OcorrenciaModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OcorrenciaModeloImplCopyWith<_$OcorrenciaModeloImpl> get copyWith =>
      __$$OcorrenciaModeloImplCopyWithImpl<_$OcorrenciaModeloImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OcorrenciaModeloImplToJson(this);
  }
}

abstract class _OcorrenciaModelo extends OcorrenciaModelo {
  const factory _OcorrenciaModelo({
    required final String id,
    required final String titulo,
    required final String descricao,
    required final double latitude,
    required final double longitude,
    required final String status,
    required final DateTime criadoEm,
    final List<String> imagensUrls,
  }) = _$OcorrenciaModeloImpl;
  const _OcorrenciaModelo._() : super._();

  factory _OcorrenciaModelo.fromJson(Map<String, dynamic> json) =
      _$OcorrenciaModeloImpl.fromJson;

  @override
  String get id;
  @override
  String get titulo;
  @override
  String get descricao;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get status;
  @override
  DateTime get criadoEm;
  @override
  List<String> get imagensUrls;

  /// Create a copy of OcorrenciaModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcorrenciaModeloImplCopyWith<_$OcorrenciaModeloImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
