import '../nucleo/rede/estado_rede.dart';

/// Serviço de verificação de conectividade (implementação futura).
abstract interface class ConectividadeServico {
  Stream<EstadoRede> observarEstado();

  Future<bool> estaConectado();
}

class ConectividadeServicoImpl implements ConectividadeServico {
  @override
  Stream<EstadoRede> observarEstado() async* {
    yield EstadoRede.conectado;
  }

  @override
  Future<bool> estaConectado() async => true;
}
