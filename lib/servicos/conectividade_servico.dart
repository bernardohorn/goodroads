import 'package:connectivity_plus/connectivity_plus.dart';

import '../nucleo/rede/estado_rede.dart';

/// Serviço de verificação de conectividade.
abstract interface class ConectividadeServico {
  Stream<EstadoRede> observarEstado();

  Future<bool> estaConectado();
}

class ConectividadeServicoImpl implements ConectividadeServico {
  ConectividadeServicoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Stream<EstadoRede> observarEstado() {
    return _connectivity.onConnectivityChanged.map(_mapearEstado);
  }

  @override
  Future<bool> estaConectado() async {
    final resultado = await _connectivity.checkConnectivity();
    return !_ehDesconectado(resultado);
  }

  EstadoRede _mapearEstado(List<ConnectivityResult> resultados) {
    if (_ehDesconectado(resultados)) return EstadoRede.desconectado;
    return EstadoRede.conectado;
  }

  bool _ehDesconectado(List<ConnectivityResult> resultados) {
    return resultados.isEmpty ||
        resultados.every((r) => r == ConnectivityResult.none);
  }
}
