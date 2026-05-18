import '../modelos/ocorrencia_modelo.dart';

/// Fonte remota de ocorrências (API/Firebase — implementação futura).
abstract interface class OcorrenciasRemotaFonte {
  Future<List<OcorrenciaModelo>> listar();

  Future<OcorrenciaModelo> obterPorId(String id);

  Future<OcorrenciaModelo> criar(OcorrenciaModelo modelo);
}
