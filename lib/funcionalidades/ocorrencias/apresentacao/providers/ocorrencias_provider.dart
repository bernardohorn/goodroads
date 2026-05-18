import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../compartilhado/modelos/resultado.dart';
import '../../dados/repositorios/ocorrencias_repositorio_impl.dart';
import '../../dominio/casos_uso/listar_ocorrencias_caso_uso.dart';
import '../../dominio/entidades/ocorrencia_entidade.dart';
import '../../dominio/repositorios/ocorrencias_repositorio.dart';

final ocorrenciasRepositorioProvider = Provider<OcorrenciasRepositorio>(
  (ref) => OcorrenciasRepositorioImpl(),
);

final listarOcorrenciasCasoUsoProvider = Provider<ListarOcorrenciasCasoUso>(
  (ref) => ListarOcorrenciasCasoUso(ref.watch(ocorrenciasRepositorioProvider)),
);

final ocorrenciasListaProvider =
    FutureProvider<List<OcorrenciaEntidade>>((ref) async {
  final casoUso = ref.watch(listarOcorrenciasCasoUsoProvider);
  final resultado = await casoUso.executar();
  return switch (resultado) {
    Sucesso(:final dados) => dados,
    Erro() => [],
  };
});
