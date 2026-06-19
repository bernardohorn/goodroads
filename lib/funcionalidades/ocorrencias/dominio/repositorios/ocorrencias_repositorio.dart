import '../../../../compartilhado/modelos/resultado.dart';
import '../entidades/ocorrencia_entidade.dart';

/// Contrato do repositório de ocorrências.
abstract interface class OcorrenciasRepositorio {
  Future<Resultado<List<OcorrenciaEntidade>>> listar();

  Future<Resultado<OcorrenciaEntidade>> obterPorId(String id);

  Future<Resultado<OcorrenciaEntidade>> criar(OcorrenciaEntidade ocorrencia);

  Future<Resultado<OcorrenciaEntidade>> atualizar(
    OcorrenciaEntidade ocorrencia, {
    String? observacao,
  });
}
