import '../../../../compartilhado/modelos/resultado.dart';
import '../entidades/ocorrencia_entidade.dart';
import '../repositorios/ocorrencias_repositorio.dart';

/// Caso de uso: listar ocorrências.
class ListarOcorrenciasCasoUso {
  const ListarOcorrenciasCasoUso(this._repositorio);

  final OcorrenciasRepositorio _repositorio;

  Future<Resultado<List<OcorrenciaEntidade>>> executar() {
    return _repositorio.listar();
  }
}
