import 'package:flutter/material.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';

/// Página de notificações (estrutura base).
class NotificacoesPagina extends StatelessWidget {
  const NotificacoesPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: const PaginaPlaceholder(
        titulo: 'Notificações',
        subtitulo: 'Alertas e avisos em desenvolvimento',
        icone: Icons.notifications,
      ),
    );
  }
}
