import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/campo_texto.dart';
import '../../../../nucleo/utilitarios/formatador_cpf.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../autenticacao/apresentacao/providers/autenticacao_provider.dart';

/// Página de perfil do usuário.
class PerfilPagina extends ConsumerWidget {
  const PerfilPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(autenticacaoControladorProvider).valueOrNull;
    final perfilLocal = ref.watch(perfilLocalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RotasNomes.configuracoes),
          ),
        ],
      ),
      body: usuario == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                perfilLocal.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (dados) => Column(
                    children: [
                      _CampoPerfil(
                        rotulo: 'Nome',
                        valor: usuario.nome,
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
                _CampoPerfil(
                  rotulo: 'E-mail',
                  valor: usuario.email,
                  mostrarEditar: true,
                  aoEditar: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Edição de e-mail requer endpoint PATCH /api/usuarios/me '
                          '(não implementado no backend).',
                        ),
                      ),
                    );
                  },
                ),
                if (usuarioEhAdmin(usuario))
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.go(RotasNomes.administrativoPainel),
                      icon: const Icon(Icons.admin_panel_settings_outlined),
                      label: const Text('Painel administrativo'),
                    ),
                  ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => _mostrarAlterarSenha(context),
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Alterar senha'),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Alteração de senha requer POST /api/auth/alterar-senha '
                    'no backend (não existe em server.js).',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
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
    this.mostrarEditar = false,
    this.aoEditar,
  });

  final String rotulo;
  final String valor;
  final bool mostrarEditar;
  final VoidCallback? aoEditar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rotulo, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(valor, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          if (mostrarEditar)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: aoEditar,
            ),
        ],
      ),
    );
  }
}
