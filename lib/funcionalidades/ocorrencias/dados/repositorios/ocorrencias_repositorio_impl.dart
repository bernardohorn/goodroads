import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/erros/falha.dart';
import '../../dominio/entidades/ocorrencia_entidade.dart';
import '../../dominio/repositorios/ocorrencias_repositorio.dart';

/// Implementação stub do repositório de ocorrências.
class OcorrenciasRepositorioImpl implements OcorrenciasRepositorio {
  @override
  Future<Resultado<List<OcorrenciaEntidade>>> listar() async {
    return const Sucesso([]);
  }

  @override
  Future<Resultado<OcorrenciaEntidade>> obterPorId(String id) async {
    return const Erro(FalhaDesconhecida());
  }

  @override
  Future<Resultado<OcorrenciaEntidade>> criar(
    OcorrenciaEntidade ocorrencia,
  ) async {
    return Sucesso(ocorrencia);
  }

  @override
  Future<Resultado<OcorrenciaEntidade>> atualizar(
    OcorrenciaEntidade ocorrencia,
  ) async {
    return Sucesso(ocorrencia);
  }
}
