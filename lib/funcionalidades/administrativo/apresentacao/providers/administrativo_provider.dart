import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';
import '../../dados/fontes_dados/relatorios_remota_fonte.dart';

final relatoriosRemotaFonteProvider = Provider<RelatoriosRemotaFonte>(
  (ref) => RelatoriosRemotaFonte(ref.watch(dioProvider)),
);

final resumoRelatorioProvider =
    FutureProvider<ResumoRelatorioModelo>((ref) async {
  final fonte = ref.watch(relatoriosRemotaFonteProvider);
  return fonte.obterResumo();
});

/// Ocorrências filtradas para o mapa administrativo.
final ocorrenciasAdminMapaProvider =
    FutureProvider<List<OcorrenciaEntidade>>((ref) async {
  final filtros = ref.watch(filtrosAdminProvider);
  final lista = await ref.watch(ocorrenciasListaProvider.future);

  return lista.where((o) {
    if (filtros.status != null && o.status != filtros.status) return false;
    if (filtros.tipoProblema != null &&
        o.tipoProblema != filtros.tipoProblema) {
      return false;
    }
    if (filtros.dataInicio != null && o.criadoEm.isBefore(filtros.dataInicio!)) {
      return false;
    }
    if (filtros.dataFim != null && o.criadoEm.isAfter(filtros.dataFim!)) {
      return false;
    }
    return true;
  }).toList();
});

class FiltrosAdmin {
  const FiltrosAdmin({
    this.status,
    this.tipoProblema,
    this.dataInicio,
    this.dataFim,
    this.busca,
  });

  final String? status;
  final String? tipoProblema;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final String? busca;

  FiltrosAdmin copyWith({
    String? status,
    String? tipoProblema,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? busca,
    bool limparStatus = false,
    bool limparTipo = false,
  }) {
    return FiltrosAdmin(
      status: limparStatus ? null : (status ?? this.status),
      tipoProblema: limparTipo ? null : (tipoProblema ?? this.tipoProblema),
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      busca: busca ?? this.busca,
    );
  }
}

class FiltrosAdminNotifier extends Notifier<FiltrosAdmin> {
  @override
  FiltrosAdmin build() => const FiltrosAdmin();

  void definirStatus(String? status) {
    state = state.copyWith(status: status, limparStatus: status == null);
    ref.invalidate(ocorrenciasAdminMapaProvider);
  }

  void definirTipo(String? tipo) {
    state = state.copyWith(tipoProblema: tipo, limparTipo: tipo == null);
    ref.invalidate(ocorrenciasAdminMapaProvider);
  }
}

final filtrosAdminProvider =
    NotifierProvider<FiltrosAdminNotifier, FiltrosAdmin>(
  FiltrosAdminNotifier.new,
);
