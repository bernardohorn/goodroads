import 'package:freezed_annotation/freezed_annotation.dart';

part 'documento_consulta_modelo.freezed.dart';
part 'documento_consulta_modelo.g.dart';

/// Resposta da consulta de CPF ou CNPJ.
@freezed
class DocumentoConsultaModelo with _$DocumentoConsultaModelo {
  const factory DocumentoConsultaModelo({
    required String documento,
    required String tipo,
    String? nome,
    String? razaoSocial,
    String? situacao,
  }) = _DocumentoConsultaModelo;

  factory DocumentoConsultaModelo.fromJson(Map<String, dynamic> json) =>
      _$DocumentoConsultaModeloFromJson(json);
}
