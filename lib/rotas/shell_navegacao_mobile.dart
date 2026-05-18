import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell de navegação inferior para o aplicativo mobile.
class ShellNavegacaoMobile extends StatelessWidget {
  const ShellNavegacaoMobile({
    super.key,
    required this.shell,
  });

  final StatefulNavigationShell shell;

  void _irParaIndice(int indice) {
    shell.goBranch(
      indice,
      initialLocation: indice == shell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _irParaIndice,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.report_outlined),
            selectedIcon: Icon(Icons.report),
            label: 'Ocorrências',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mapas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

/// Índices das abas do shell mobile.
abstract final class IndiceNavegacaoMobile {
  static const int inicio = 0;
  static const int ocorrencias = 1;
  static const int mapas = 2;
  static const int perfil = 3;
}
