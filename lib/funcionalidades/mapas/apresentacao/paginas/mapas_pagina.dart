import 'package:flutter/material.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';

/// Página de mapas (estrutura base).
class MapasPagina extends StatelessWidget {
  const MapasPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapas')),
      body: const PaginaPlaceholder(
        titulo: 'Mapas',
        subtitulo: 'Visualização geográfica e marcadores em desenvolvimento',
        icone: Icons.map,
      ),
    );
  }
}
