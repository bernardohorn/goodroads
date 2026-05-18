import 'package:flutter/material.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';

/// Gestão de usuários no painel administrativo.
class AdministrativoUsuariosPagina extends StatelessWidget {
  const AdministrativoUsuariosPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PaginaPlaceholder(
        titulo: 'Usuários — Admin',
        subtitulo: 'Gestão de agentes e permissões em desenvolvimento',
        icone: Icons.people,
      ),
    );
  }
}
