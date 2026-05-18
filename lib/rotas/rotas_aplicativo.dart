import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../funcionalidades/administrativo/apresentacao/paginas/administrativo_ocorrencias_pagina.dart';
import '../funcionalidades/administrativo/apresentacao/paginas/administrativo_painel_pagina.dart';
import '../funcionalidades/administrativo/apresentacao/paginas/administrativo_usuarios_pagina.dart';
import '../funcionalidades/autenticacao/apresentacao/paginas/login_pagina.dart';
import '../funcionalidades/autenticacao/apresentacao/paginas/registro_pagina.dart';
import '../funcionalidades/configuracoes/apresentacao/paginas/configuracoes_pagina.dart';
import '../funcionalidades/inicio/apresentacao/paginas/inicio_pagina.dart';
import '../funcionalidades/mapas/apresentacao/paginas/mapas_pagina.dart';
import '../funcionalidades/notificacoes/apresentacao/paginas/notificacoes_pagina.dart';
import '../funcionalidades/ocorrencias/apresentacao/paginas/ocorrencias_pagina.dart';
import '../funcionalidades/perfil/apresentacao/paginas/perfil_pagina.dart';
import 'guarda_autenticacao.dart';
import 'rotas_nomes.dart';
import 'shell_navegacao_administrativo.dart';
import 'shell_navegacao_mobile.dart';

final _chaveRaizNavegador = GlobalKey<NavigatorState>(
  debugLabel: 'raiz',
);

/// Configuração central do GoRouter.
GoRouter criarRoteador(Ref ref) {
  return GoRouter(
    navigatorKey: _chaveRaizNavegador,
    initialLocation: RotasNomes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) => guardaAutenticacao(ref, state.matchedLocation),
    routes: [
      GoRoute(
        path: RotasNomes.login,
        name: 'login',
        builder: (context, state) => const LoginPagina(),
      ),
      GoRoute(
        path: RotasNomes.registro,
        name: 'registro',
        builder: (context, state) => const RegistroPagina(),
      ),
      GoRoute(
        path: RotasNomes.notificacoes,
        name: 'notificacoes',
        builder: (context, state) => const NotificacoesPagina(),
      ),
      GoRoute(
        path: RotasNomes.configuracoes,
        name: 'configuracoes',
        builder: (context, state) => const ConfiguracoesPagina(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            ShellNavegacaoMobile(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.inicio,
                name: 'inicio',
                builder: (context, state) => const InicioPagina(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.ocorrencias,
                name: 'ocorrencias',
                builder: (context, state) => const OcorrenciasPagina(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.mapas,
                name: 'mapas',
                builder: (context, state) => const MapasPagina(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.perfil,
                name: 'perfil',
                builder: (context, state) => const PerfilPagina(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            ShellNavegacaoAdministrativo(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.administrativoPainel,
                name: 'administrativo-painel',
                builder: (context, state) => const AdministrativoPainelPagina(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.administrativoOcorrencias,
                name: 'administrativo-ocorrencias',
                builder: (context, state) =>
                    const AdministrativoOcorrenciasPagina(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.administrativoUsuarios,
                name: 'administrativo-usuarios',
                builder: (context, state) => const AdministrativoUsuariosPagina(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
