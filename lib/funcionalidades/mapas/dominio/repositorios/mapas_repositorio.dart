import '../../../../compartilhado/modelos/resultado.dart';
import '../entidades/localizacao_entidade.dart';

/// Contrato do repositório de mapas.
abstract interface class MapasRepositorio {
  Future<Resultado<LocalizacaoEntidade>> obterPosicaoAtual();
}
