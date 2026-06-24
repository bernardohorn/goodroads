import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/campo_texto.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../nucleo/utilitarios/formatador_cpf.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../autenticacao/apresentacao/providers/autenticacao_provider.dart';
import '../../../autenticacao/dados/repositorios/autenticacao_repositorio_impl.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';

/// Página de perfil do usuário.
class PerfilPagina extends ConsumerWidget {
  const PerfilPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(autenticacaoControladorProvider).valueOrNull;
    final perfilLocal = ref.watch(perfilLocalProvider);
    final ocorrencias = ref.watch(ocorrenciasListaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _mostrarEditarPerfil(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RotasNomes.configuracoes),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: usuario == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(perfilLocalProvider);
                  ref.invalidate(ocorrenciasListaProvider);
                },
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _CampoPerfil(rotulo: 'Nome', valor: usuario.nome),
                    _CampoPerfil(rotulo: 'E-mail', valor: usuario.email),
                    perfilLocal.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (dados) => Column(
                        children: [
                          _CampoPerfil(
                            rotulo: 'Telefone',
                            valor: dados.$3 ?? '—',
                          ),
                          _CampoPerfil(
                            rotulo: 'CPF',
                            valor: dados.$1 != null
                                ? FormatadorCpf.aplicarMascara(dados.$1!)
                                : '—',
                          ),
                          _CampoPerfil(
                            rotulo: 'Data de nascimento',
                            valor: dados.$2 ?? '—',
                          ),
                        ],
                      ),
                    ),
                    if (usuarioEhAdmin(usuario))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.go(RotasNomes.administrativoPainel),
                          icon: const Icon(
                              Icons.admin_panel_settings_outlined),
                          label: const Text('Painel administrativo'),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Minhas ocorrências',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ocorrencias.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (e, _) => EstadoErroCarregamento(
                        erro: e,
                        aoTentarNovamente: () =>
                            ref.refresh(ocorrenciasListaProvider),
                      ),
                      data: (lista) {
                        final minhas = lista
                            .where((o) => o.usuarioId == usuario.id)
                            .toList()
                          ..sort(
                              (a, b) => b.criadoEm.compareTo(a.criadoEm));

                        if (minhas.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                  'Nenhuma ocorrência registrada.'),
                            ),
                          );
                        }

                        final exibir = minhas.take(5).toList();
                        return Column(
                          children: [
                            ...exibir.map(
                              (o) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: CartaoOcorrenciaResumo(
                                  ocorrencia: o,
                                  aoTocar: () => context.push(
                                    RotasNomes.detalheOcorrencia
                                        .replaceFirst(':id', o.id),
                                  ),
                                ),
                              ),
                            ),
                            if (minhas.length > 5)
                              TextButton(
                                onPressed: () =>
                                    context.push(RotasNomes.historico),
                                child: const Text('Ver todas'),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => _mostrarAlterarSenha(context),
                      icon: const Icon(Icons.lock_outline),
                      label: const Text('Alterar senha'),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(autenticacaoControladorProvider.notifier).sair();
          if (context.mounted) context.go(RotasNomes.login);
        },
        icon: const Icon(Icons.logout),
        label: const Text('Sair'),
      ),
    );
  }

  void _mostrarEditarPerfil(BuildContext context, WidgetRef ref) {
    final usuario =
        ref.read(autenticacaoControladorProvider).valueOrNull;
    final perfilData = ref.read(perfilLocalProvider).valueOrNull;
    final nomeCtrl = TextEditingController(text: usuario?.nome ?? '');
    final telefoneCtrl =
        TextEditingController(text: perfilData?.$3 ?? '');

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CampoTexto(
              rotulo: 'Nome',
              controlador: nomeCtrl,
            ),
            const SizedBox(height: 12),
            CampoTexto(
              rotulo: 'Telefone',
              controlador: telefoneCtrl,
              tipoTeclado: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final repo = ref.read(autenticacaoRepositorioProvider)
                  as AutenticacaoRepositorioImpl;
              final telefone = telefoneCtrl.text.trim();
              if (telefone.isNotEmpty) {
                await repo.salvarTelefoneLocal(telefone);
              }
              ref.invalidate(perfilLocalProvider);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perfil atualizado.')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _mostrarAlterarSenha(BuildContext context) {
    final senhaAtual = TextEditingController();
    final novaSenha = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alterar senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CampoTexto(
              rotulo: 'Senha atual',
              controlador: senhaAtual,
              ocultarTexto: true,
            ),
            const SizedBox(height: 12),
            CampoTexto(
              rotulo: 'Nova senha',
              controlador: novaSenha,
              ocultarTexto: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Endpoint de alteração de senha ainda não disponível no backend.',
                  ),
                ),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

class _CampoPerfil extends StatelessWidget {
  const _CampoPerfil({
    required this.rotulo,
    required this.valor,
  });

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rotulo, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(valor, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
