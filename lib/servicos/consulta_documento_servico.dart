import 'package:dio/dio.dart';

import '../compartilhado/modelos/documento_consulta_modelo.dart';
import '../compartilhado/modelos/resultado.dart';
import '../configuracao/ambiente/variaveis_ambiente.dart';
import '../nucleo/constantes/constantes_documento.dart';
import '../nucleo/erros/falha.dart';

/// Serviço de consulta de CPF/CNPJ via API externa.
abstract interface class ConsultaDocumentoServico {
  Future<Resultado<DocumentoConsultaModelo>> consultarCpf(String cpf);

  Future<Resultado<DocumentoConsultaModelo>> consultarCnpj(String cnpj);
}

class ConsultaDocumentoServicoImpl implements ConsultaDocumentoServico {
  ConsultaDocumentoServicoImpl(this._dio);

  final Dio _dio;

  @override
  Future<Resultado<DocumentoConsultaModelo>> consultarCpf(String cpf) {
    return _consultar(
      caminho: ConstantesDocumento.caminhoCpf,
      documento: cpf,
      tipo: 'cpf',
    );
  }

  @override
  Future<Resultado<DocumentoConsultaModelo>> consultarCnpj(String cnpj) {
    return _consultar(
      caminho: ConstantesDocumento.caminhoCnpj,
      documento: cnpj,
      tipo: 'cnpj',
    );
  }

  Future<Resultado<DocumentoConsultaModelo>> _consultar({
    required String caminho,
    required String documento,
    required String tipo,
  }) async {
    if (VariaveisAmbiente.cpfCnpjApiUrl.isEmpty) {
      return const Erro(
        FalhaDesconhecida('API de CPF/CNPJ não configurada no .env'),
      );
    }

    try {
      final resposta = await _dio.get<Map<String, dynamic>>(
        caminho,
        queryParameters: {'documento': documento},
        options: Options(
          headers: {
            if (ConstantesDocumento.token.isNotEmpty)
              'Authorization': 'Bearer ${ConstantesDocumento.token}',
          },
        ),
      );

      final dados = resposta.data;
      if (dados == null) {
        return const Erro(FalhaDesconhecida('Resposta vazia da API'));
      }

      final modelo = DocumentoConsultaModelo.fromJson({
        ...dados,
        'documento': documento,
        'tipo': tipo,
      });

      return Sucesso(modelo);
    } on DioException {
      return const Erro(FalhaRede());
    } catch (_) {
      return const Erro(FalhaDesconhecida());
    }
  }
}
