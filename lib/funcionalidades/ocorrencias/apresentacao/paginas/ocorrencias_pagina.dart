import 'package:flutter/material.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';

/// Página de listagem de ocorrências (estrutura base).
class OcorrenciasPagina extends StatelessWidget {
  const OcorrenciasPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocorrências')),
      body: const PaginaPlaceholder(
        titulo: 'Ocorrências',
        subtitulo: 'Lista e registro de ocorrências em desenvolvimento',
        icone: Icons.report,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Nova ocorrência',
        child: const Icon(Icons.add),
      ),
    );
  }
}
