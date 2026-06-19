import '../modelos/ocorrencia_modelo.dart';

/// Fonte remota de ocorrências (API REST).
abstract interface class OcorrenciasRemotaFonte {
  Future<List<OcorrenciaModelo>> listar();

  Future<List<OcorrenciaModelo>> listarProximas({
    required double latitude,
    required double longitude,
    double raioKm,
  });

  Future<OcorrenciaModelo> obterPorId(String id);

  Future<OcorrenciaModelo> criar(OcorrenciaModelo modelo);

  Future<OcorrenciaModelo> atualizarStatus({
    required String id,
    required String status,
    String? observacao,
  });
}
