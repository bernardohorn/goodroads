import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../configuracao/ambiente/variaveis_ambiente.dart';
import '../../rotas/rotas_aplicativo.dart';
import '../../servicos/armazenamento_local_servico.dart';
import '../../servicos/conectividade_servico.dart';
import '../../servicos/consulta_documento_servico.dart';
import '../../servicos/geocodificacao_servico.dart';
import '../../servicos/geolocalizacao_servico.dart';
import '../../servicos/rota_servico.dart';
import '../../servicos/selecao_imagem_servico.dart';
import '../constantes/constantes_api.dart';
import '../rede/cliente_http.dart';
import '../rede/dio_cliente.dart';

/// Instância global do Dio.
final dioProvider = Provider<Dio>((ref) {
  return criarDio(
    urlBase: ConstantesApi.urlBase,
    obterToken: () async {
      final armazenamento = ref.read(armazenamentoLocalServicoProvider);
      return armazenamento.ler('token_autenticacao');
    },
  );
});

/// Cliente HTTP baseado em Dio.
final clienteHttpProvider = Provider<ClienteHttp>(
  (ref) => DioCliente(ref.watch(dioProvider)),
);

/// Dio dedicado à API de CPF/CNPJ (base URL separada).
final dioDocumentoProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: VariaveisAmbiente.cpfCnpjApiUrl,
      connectTimeout: ConstantesApi.tempoLimiteRequisicao,
      receiveTimeout: ConstantesApi.tempoLimiteRequisicao,
    ),
  );
});

final conectividadeServicoProvider = Provider<ConectividadeServico>(
  (ref) => ConectividadeServicoImpl(),
);

final armazenamentoLocalServicoProvider = Provider<ArmazenamentoLocalServico>(
  (ref) => ArmazenamentoLocalServicoImpl.obter(),
);

final geolocalizacaoServicoProvider = Provider<GeolocalizacaoServico>(
  (ref) => GeolocalizacaoServicoImpl(),
);

final geocodificacaoServicoProvider = Provider<GeocodificacaoServico>(
  (ref) => GeocodificacaoServicoImpl(),
);

final selecaoImagemServicoProvider = Provider<SelecaoImagemServico>(
  (ref) => SelecaoImagemServicoImpl(),
);

final consultaDocumentoServicoProvider = Provider<ConsultaDocumentoServico>(
  (ref) => ConsultaDocumentoServicoImpl(ref.watch(dioDocumentoProvider)),
);

/// Serviço de cálculo de rotas (Google Directions API).
final rotaServicoProvider = Provider<RotaServico>(
  (ref) => RotaServicoImpl(),
);

final roteadorProvider = Provider((ref) => criarRoteador(ref));
