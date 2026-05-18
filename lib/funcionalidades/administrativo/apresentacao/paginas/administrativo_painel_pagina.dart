import 'package:flutter/material.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';

/// Painel principal do módulo administrativo.
class AdministrativoPainelPagina extends StatelessWidget {
  const AdministrativoPainelPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PaginaPlaceholder(
        titulo: 'Painel Administrativo',
        subtitulo: 'Dashboard e métricas em desenvolvimento',
        icone: Icons.dashboard,
      ),
    );
  }
}
