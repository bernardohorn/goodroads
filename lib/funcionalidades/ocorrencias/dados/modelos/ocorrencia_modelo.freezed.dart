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
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'criado_em')
  DateTime get criadoEm => throw _privateConstructorUsedError;
  @JsonKey(name: 'imagens_urls')
  List<String> get imagensUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipo_problema')
  String? get tipoProblema => throw _privateConstructorUsedError;
  String? get urgencia => throw _privateConstructorUsedError;
  String? get municipio => throw _privateConstructorUsedError;
  String? get protocolo => throw _privateConstructorUsedError;
  @JsonKey(name: 'usuario_id', fromJson: _idOpcionalFromJson)
  String? get usuarioId => throw _privateConstructorUsedError;
  List<HistoricoStatusModelo> get historico =>
      throw _privateConstructorUsedError;

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
    @JsonKey(fromJson: _idFromJson) String id,
    String titulo,
    String descricao,
    double latitude,
    double longitude,
    String status,
    @JsonKey(name: 'criado_em') DateTime criadoEm,
    @JsonKey(name: 'imagens_urls') List<String> imagensUrls,
    @JsonKey(name: 'tipo_problema') String? tipoProblema,
    String? urgencia,
    String? municipio,
    String? protocolo,
    @JsonKey(name: 'usuario_id', fromJson: _idOpcionalFromJson)
    String? usuarioId,
    List<HistoricoStatusModelo> historico,
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
    Object? tipoProblema = freezed,
    Object? urgencia = freezed,
    Object? municipio = freezed,
    Object? protocolo = freezed,
    Object? usuarioId = freezed,
    Object? historico = null,
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
            tipoProblema: freezed == tipoProblema
                ? _value.tipoProblema
                : tipoProblema // ignore: cast_nullable_to_non_nullable
                      as String?,
            urgencia: freezed == urgencia
                ? _value.urgencia
                : urgencia // ignore: cast_nullable_to_non_nullable
                      as String?,
            municipio: freezed == municipio
                ? _value.municipio
                : municipio // ignore: cast_nullable_to_non_nullable
                      as String?,
            protocolo: freezed == protocolo
                ? _value.protocolo
                : protocolo // ignore: cast_nullable_to_non_nullable
                      as String?,
            usuarioId: freezed == usuarioId
                ? _value.usuarioId
                : usuarioId // ignore: cast_nullable_to_non_nullable
                      as String?,
            historico: null == historico
                ? _value.historico
                : historico // ignore: cast_nullable_to_non_nullable
                      as List<HistoricoStatusModelo>,
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
    @JsonKey(fromJson: _idFromJson) String id,
    String titulo,
    String descricao,
    double latitude,
    double longitude,
    String status,
    @JsonKey(name: 'criado_em') DateTime criadoEm,
    @JsonKey(name: 'imagens_urls') List<String> imagensUrls,
    @JsonKey(name: 'tipo_problema') String? tipoProblema,
    String? urgencia,
    String? municipio,
    String? protocolo,
    @JsonKey(name: 'usuario_id', fromJson: _idOpcionalFromJson)
    String? usuarioId,
    List<HistoricoStatusModelo> historico,
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
    Object? tipoProblema = freezed,
    Object? urgencia = freezed,
    Object? municipio = freezed,
    Object? protocolo = freezed,
    Object? usuarioId = freezed,
    Object? historico = null,
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
        tipoProblema: freezed == tipoProblema
            ? _value.tipoProblema
            : tipoProblema // ignore: cast_nullable_to_non_nullable
                  as String?,
        urgencia: freezed == urgencia
            ? _value.urgencia
            : urgencia // ignore: cast_nullable_to_non_nullable
                  as String?,
        municipio: freezed == municipio
            ? _value.municipio
            : municipio // ignore: cast_nullable_to_non_nullable
                  as String?,
        protocolo: freezed == protocolo
            ? _value.protocolo
            : protocolo // ignore: cast_nullable_to_non_nullable
                  as String?,
        usuarioId: freezed == usuarioId
            ? _value.usuarioId
            : usuarioId // ignore: cast_nullable_to_non_nullable
                  as String?,
        historico: null == historico
            ? _value._historico
            : historico // ignore: cast_nullable_to_non_nullable
                  as List<HistoricoStatusModelo>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OcorrenciaModeloImpl extends _OcorrenciaModelo {
  const _$OcorrenciaModeloImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    required this.titulo,
    required this.descricao,
    required this.latitude,
    required this.longitude,
    required this.status,
    @JsonKey(name: 'criado_em') required this.criadoEm,
    @JsonKey(name: 'imagens_urls') final List<String> imagensUrls = const [],
    @JsonKey(name: 'tipo_problema') this.tipoProblema,
    this.urgencia,
    this.municipio,
    this.protocolo,
    @JsonKey(name: 'usuario_id', fromJson: _idOpcionalFromJson) this.usuarioId,
    final List<HistoricoStatusModelo> historico = const [],
  }) : _imagensUrls = imagensUrls,
       _historico = historico,
       super._();

  factory _$OcorrenciaModeloImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcorrenciaModeloImplFromJson(json);

  @override
  @JsonKey(fromJson: _idFromJson)
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
  @JsonKey(name: 'criado_em')
  final DateTime criadoEm;
  final List<String> _imagensUrls;
  @override
  @JsonKey(name: 'imagens_urls')
  List<String> get imagensUrls {
    if (_imagensUrls is EqualUnmodifiableListView) return _imagensUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imagensUrls);
  }

  @override
  @JsonKey(name: 'tipo_problema')
  final String? tipoProblema;
  @override
  final String? urgencia;
  @override
  final String? municipio;
  @override
  final String? protocolo;
  @override
  @JsonKey(name: 'usuario_id', fromJson: _idOpcionalFromJson)
  final String? usuarioId;
  final List<HistoricoStatusModelo> _historico;
  @override
  @JsonKey()
  List<HistoricoStatusModelo> get historico {
    if (_historico is EqualUnmodifiableListView) return _historico;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_historico);
  }

  @override
  String toString() {
    return 'OcorrenciaModelo(id: $id, titulo: $titulo, descricao: $descricao, latitude: $latitude, longitude: $longitude, status: $status, criadoEm: $criadoEm, imagensUrls: $imagensUrls, tipoProblema: $tipoProblema, urgencia: $urgencia, municipio: $municipio, protocolo: $protocolo, usuarioId: $usuarioId, historico: $historico)';
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
            ) &&
            (identical(other.tipoProblema, tipoProblema) ||
                other.tipoProblema == tipoProblema) &&
            (identical(other.urgencia, urgencia) ||
                other.urgencia == urgencia) &&
            (identical(other.municipio, municipio) ||
                other.municipio == municipio) &&
            (identical(other.protocolo, protocolo) ||
                other.protocolo == protocolo) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            const DeepCollectionEquality().equals(
              other._historico,
              _historico,
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
    tipoProblema,
    urgencia,
    municipio,
    protocolo,
    usuarioId,
    const DeepCollectionEquality().hash(_historico),
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
    @JsonKey(fromJson: _idFromJson) required final String id,
    required final String titulo,
    required final String descricao,
    required final double latitude,
    required final double longitude,
    required final String status,
    @JsonKey(name: 'criado_em') required final DateTime criadoEm,
    @JsonKey(name: 'imagens_urls') final List<String> imagensUrls,
    @JsonKey(name: 'tipo_problema') final String? tipoProblema,
    final String? urgencia,
    final String? municipio,
    final String? protocolo,
    @JsonKey(name: 'usuario_id', fromJson: _idOpcionalFromJson)
    final String? usuarioId,
    final List<HistoricoStatusModelo> historico,
  }) = _$OcorrenciaModeloImpl;
  const _OcorrenciaModelo._() : super._();

  factory _OcorrenciaModelo.fromJson(Map<String, dynamic> json) =
      _$OcorrenciaModeloImpl.fromJson;

  @override
  @JsonKey(fromJson: _idFromJson)
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
  @JsonKey(name: 'criado_em')
  DateTime get criadoEm;
  @override
  @JsonKey(name: 'imagens_urls')
  List<String> get imagensUrls;
  @override
  @JsonKey(name: 'tipo_problema')
  String? get tipoProblema;
  @override
  String? get urgencia;
  @override
  String? get municipio;
  @override
  String? get protocolo;
  @override
  @JsonKey(name: 'usuario_id', fromJson: _idOpcionalFromJson)
  String? get usuarioId;
  @override
  List<HistoricoStatusModelo> get historico;

  /// Create a copy of OcorrenciaModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcorrenciaModeloImplCopyWith<_$OcorrenciaModeloImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HistoricoStatusModelo _$HistoricoStatusModeloFromJson(
  Map<String, dynamic> json,
) {
  return _HistoricoStatusModelo.fromJson(json);
}

/// @nodoc
mixin _$HistoricoStatusModelo {
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_alteracao')
  DateTime get dataAlteracao => throw _privateConstructorUsedError;
  String? get observacao => throw _privateConstructorUsedError;
  String? get responsavel => throw _privateConstructorUsedError;

  /// Serializes this HistoricoStatusModelo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoricoStatusModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoricoStatusModeloCopyWith<HistoricoStatusModelo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoricoStatusModeloCopyWith<$Res> {
  factory $HistoricoStatusModeloCopyWith(
    HistoricoStatusModelo value,
    $Res Function(HistoricoStatusModelo) then,
  ) = _$HistoricoStatusModeloCopyWithImpl<$Res, HistoricoStatusModelo>;
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'data_alteracao') DateTime dataAlteracao,
    String? observacao,
    String? responsavel,
  });
}

/// @nodoc
class _$HistoricoStatusModeloCopyWithImpl<
  $Res,
  $Val extends HistoricoStatusModelo
>
    implements $HistoricoStatusModeloCopyWith<$Res> {
  _$HistoricoStatusModeloCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoricoStatusModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? dataAlteracao = null,
    Object? observacao = freezed,
    Object? responsavel = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            dataAlteracao: null == dataAlteracao
                ? _value.dataAlteracao
                : dataAlteracao // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            observacao: freezed == observacao
                ? _value.observacao
                : observacao // ignore: cast_nullable_to_non_nullable
                      as String?,
            responsavel: freezed == responsavel
                ? _value.responsavel
                : responsavel // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HistoricoStatusModeloImplCopyWith<$Res>
    implements $HistoricoStatusModeloCopyWith<$Res> {
  factory _$$HistoricoStatusModeloImplCopyWith(
    _$HistoricoStatusModeloImpl value,
    $Res Function(_$HistoricoStatusModeloImpl) then,
  ) = __$$HistoricoStatusModeloImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'data_alteracao') DateTime dataAlteracao,
    String? observacao,
    String? responsavel,
  });
}

/// @nodoc
class __$$HistoricoStatusModeloImplCopyWithImpl<$Res>
    extends
        _$HistoricoStatusModeloCopyWithImpl<$Res, _$HistoricoStatusModeloImpl>
    implements _$$HistoricoStatusModeloImplCopyWith<$Res> {
  __$$HistoricoStatusModeloImplCopyWithImpl(
    _$HistoricoStatusModeloImpl _value,
    $Res Function(_$HistoricoStatusModeloImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HistoricoStatusModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? dataAlteracao = null,
    Object? observacao = freezed,
    Object? responsavel = freezed,
  }) {
    return _then(
      _$HistoricoStatusModeloImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        dataAlteracao: null == dataAlteracao
            ? _value.dataAlteracao
            : dataAlteracao // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        observacao: freezed == observacao
            ? _value.observacao
            : observacao // ignore: cast_nullable_to_non_nullable
                  as String?,
        responsavel: freezed == responsavel
            ? _value.responsavel
            : responsavel // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoricoStatusModeloImpl extends _HistoricoStatusModelo {
  const _$HistoricoStatusModeloImpl({
    required this.status,
    @JsonKey(name: 'data_alteracao') required this.dataAlteracao,
    this.observacao,
    this.responsavel,
  }) : super._();

  factory _$HistoricoStatusModeloImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoricoStatusModeloImplFromJson(json);

  @override
  final String status;
  @override
  @JsonKey(name: 'data_alteracao')
  final DateTime dataAlteracao;
  @override
  final String? observacao;
  @override
  final String? responsavel;

  @override
  String toString() {
    return 'HistoricoStatusModelo(status: $status, dataAlteracao: $dataAlteracao, observacao: $observacao, responsavel: $responsavel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoricoStatusModeloImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dataAlteracao, dataAlteracao) ||
                other.dataAlteracao == dataAlteracao) &&
            (identical(other.observacao, observacao) ||
                other.observacao == observacao) &&
            (identical(other.responsavel, responsavel) ||
                other.responsavel == responsavel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, dataAlteracao, observacao, responsavel);

  /// Create a copy of HistoricoStatusModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoricoStatusModeloImplCopyWith<_$HistoricoStatusModeloImpl>
  get copyWith =>
      __$$HistoricoStatusModeloImplCopyWithImpl<_$HistoricoStatusModeloImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoricoStatusModeloImplToJson(this);
  }
}

abstract class _HistoricoStatusModelo extends HistoricoStatusModelo {
  const factory _HistoricoStatusModelo({
    required final String status,
    @JsonKey(name: 'data_alteracao') required final DateTime dataAlteracao,
    final String? observacao,
    final String? responsavel,
  }) = _$HistoricoStatusModeloImpl;
  const _HistoricoStatusModelo._() : super._();

  factory _HistoricoStatusModelo.fromJson(Map<String, dynamic> json) =
      _$HistoricoStatusModeloImpl.fromJson;

  @override
  String get status;
  @override
  @JsonKey(name: 'data_alteracao')
  DateTime get dataAlteracao;
  @override
  String? get observacao;
  @override
  String? get responsavel;

  /// Create a copy of HistoricoStatusModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoricoStatusModeloImplCopyWith<_$HistoricoStatusModeloImpl>
  get copyWith => throw _privateConstructorUsedError;
}
