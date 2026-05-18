import 'package:flutter/material.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';

/// Gestão de ocorrências no painel administrativo.
class AdministrativoOcorrenciasPagina extends StatelessWidget {
  const AdministrativoOcorrenciasPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PaginaPlaceholder(
        titulo: 'Ocorrências — Admin',
        subtitulo: 'Moderação e gestão em desenvolvimento',
        icone: Icons.admin_panel_settings,
      ),
    );
  }
}
