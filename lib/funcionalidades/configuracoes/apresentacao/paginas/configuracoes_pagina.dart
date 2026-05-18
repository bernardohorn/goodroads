import 'package:flutter/material.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';

/// Página de configurações do aplicativo (estrutura base).
class ConfiguracoesPagina extends StatelessWidget {
  const ConfiguracoesPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: const PaginaPlaceholder(
        titulo: 'Configurações',
        subtitulo: 'Preferências, tema e privacidade em desenvolvimento',
        icone: Icons.settings,
      ),
    );
  }
}
