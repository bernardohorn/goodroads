import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../rotas/rotas_aplicativo.dart';
import '../../servicos/conectividade_servico.dart';
import '../../servicos/armazenamento_local_servico.dart';

/// Provedores globais compartilhados entre funcionalidades.
final conectividadeServicoProvider = Provider<ConectividadeServico>(
  (ref) => ConectividadeServicoImpl(),
);

final armazenamentoLocalServicoProvider = Provider<ArmazenamentoLocalServico>(
  (ref) => ArmazenamentoLocalServicoImpl(),
);

final roteadorProvider = Provider((ref) => criarRoteador(ref));
