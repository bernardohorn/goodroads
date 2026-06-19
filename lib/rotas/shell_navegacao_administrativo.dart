import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell de navegação lateral para o painel administrativo (web/desktop).
class ShellNavegacaoAdministrativo extends StatelessWidget {
  const ShellNavegacaoAdministrativo({
    super.key,
    required this.shell,
  });

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: shell.goBranch,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Painel'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: Text('Mapa'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.report_outlined),
                selectedIcon: Icon(Icons.report),
                label: Text('Ocorrências'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Usuários'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: shell),
        ],
      ),
    );
  }
}
