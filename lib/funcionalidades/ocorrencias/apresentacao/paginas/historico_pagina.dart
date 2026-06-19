import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../autenticacao/apresentacao/providers/autenticacao_provider.dart';
import '../../dominio/entidades/ocorrencia_entidade.dart';
import '../providers/ocorrencias_provider.dart';

/// Página de histórico de ocorrências com abas.
class HistoricoPagina extends ConsumerStatefulWidget {
  const HistoricoPagina({super.key});

  @override
  ConsumerState<HistoricoPagina> createState() => _HistoricoPaginaState();
}

class _HistoricoPaginaState extends ConsumerState<HistoricoPagina>
    with SingleTickerProviderStateMixin {
  late TabController _abas;

  @override
  void initState() {
    super.initState();
    final ehAdmin =
        usuarioEhAdmin(ref.read(autenticacaoControladorProvider).valueOrNull);
    _abas = TabController(length: ehAdmin ? 2 : 1, vsync: this);
    _abas.addListener(() {
      if (!_abas.indexIsChanging) {
        ref.read(historicoListaProvider.notifier).alterarFiltro(
              _abas.index == 0 ? 'minhas' : 'todas',
            );
      }
    });
  }

  @override
  void dispose() {
    _abas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ehAdmin =
        usuarioEhAdmin(ref.watch(autenticacaoControladorProvider).valueOrNull);
    final estado = ref.watch(historicoListaProvider);
    final notifier = ref.read(historicoListaProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        bottom: TabBar(
          controller: _abas,
          tabs: [
            const Tab(text: 'Minhas ocorrências'),
            if (ehAdmin) const Tab(text: 'Todas as ocorrências'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _abas,
        children: [
          _ListaHistorico(
            estado: estado,
            mostrarBanner: true,
            aoRecarregar: notifier.recarregar,
            aoCarregarMais: notifier.carregarMais,
            temMais: notifier.temMais,
          ),
          if (ehAdmin)
            _ListaHistorico(
              estado: estado,
              mostrarBanner: false,
              aoRecarregar: notifier.recarregar,
              aoCarregarMais: notifier.carregarMais,
              temMais: notifier.temMais,
            ),
        ],
      ),
    );
  }
}

class _ListaHistorico extends StatelessWidget {
  const _ListaHistorico({
    required this.estado,
    required this.mostrarBanner,
    required this.aoRecarregar,
    required this.aoCarregarMais,
    required this.temMais,
  });

  final AsyncValue<List<OcorrenciaEntidade>> estado;
  final bool mostrarBanner;
  final Future<void> Function() aoRecarregar;
  final VoidCallback aoCarregarMais;
  final bool temMais;

  @override
  Widget build(BuildContext context) {
    return estado.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EstadoErroCarregamento(
        erro: e,
        aoTentarNovamente: aoRecarregar,
      ),
      data: (lista) {
        if (lista.isEmpty) {
          return Center(
            child: Text(
              mostrarBanner
                  ? 'Você ainda não registrou ocorrências.'
                  : 'Nenhuma ocorrência encontrada.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: aoRecarregar,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notificacao) {
              if (notificacao.metrics.pixels >=
                      notificacao.metrics.maxScrollExtent - 200 &&
                  temMais) {
                aoCarregarMais();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: lista.length + (mostrarBanner ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                if (mostrarBanner && i == 0) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Aqui estão todas as ocorrências que você registrou '
                      'no GoodRoads Brasil.',
                    ),
                  );
                }
                final indice = mostrarBanner ? i - 1 : i;
                final o = lista[indice];
                return CartaoOcorrenciaResumo(
                  ocorrencia: o,
                  aoTocar: () => context.push(
                    RotasNomes.detalheOcorrencia.replaceFirst(':id', o.id),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
