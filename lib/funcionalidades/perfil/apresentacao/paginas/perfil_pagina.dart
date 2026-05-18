import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../autenticacao/apresentacao/providers/autenticacao_provider.dart';

/// Página de perfil do usuário (estrutura base).
class PerfilPagina extends ConsumerWidget {
  const PerfilPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: const PaginaPlaceholder(
        titulo: 'Meu perfil',
        subtitulo: 'Dados do usuário e preferências em desenvolvimento',
        icone: Icons.person,
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
}
