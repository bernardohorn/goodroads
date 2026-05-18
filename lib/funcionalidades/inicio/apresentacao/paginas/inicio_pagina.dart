import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';
import '../../../../rotas/rotas_nomes.dart';

/// Página inicial do aplicativo mobile.
class InicioPagina extends StatelessWidget {
  const InicioPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(RotasNomes.notificacoes),
          ),
        ],
      ),
      body: const PaginaPlaceholder(
        titulo: 'Bem-vindo ao GoodRoads',
        subtitulo: 'Painel resumo e atalhos em desenvolvimento',
        icone: Icons.home,
      ),
    );
  }
}
