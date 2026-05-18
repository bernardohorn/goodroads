import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/pagina_placeholder.dart';
import '../../../../rotas/rotas_nomes.dart';

/// Página de registro (estrutura base).
class RegistroPagina extends StatelessWidget {
  const RegistroPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: const PaginaPlaceholder(
        titulo: 'Registro',
        subtitulo: 'Formulário de cadastro em desenvolvimento',
        icone: Icons.person_add_outlined,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(RotasNomes.login),
        label: const Text('Voltar ao login'),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
