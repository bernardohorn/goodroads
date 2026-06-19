import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../funcionalidades/administrativo/apresentacao/paginas/administrativo_mapa_pagina.dart';
import '../funcionalidades/administrativo/apresentacao/paginas/administrativo_ocorrencias_pagina.dart';
import '../funcionalidades/administrativo/apresentacao/paginas/administrativo_painel_pagina.dart';
import '../funcionalidades/administrativo/apresentacao/paginas/administrativo_usuarios_pagina.dart';
import '../funcionalidades/autenticacao/apresentacao/paginas/login_pagina.dart';
import '../funcionalidades/autenticacao/apresentacao/paginas/registro_pagina.dart';
import '../funcionalidades/configuracoes/apresentacao/paginas/configuracoes_pagina.dart';
import '../funcionalidades/inicio/apresentacao/paginas/inicio_pagina.dart';
import '../funcionalidades/mapas/apresentacao/paginas/mapas_pagina.dart';
import '../funcionalidades/notificacoes/apresentacao/paginas/notificacoes_pagina.dart';
import '../funcionalidades/ocorrencias/apresentacao/paginas/historico_pagina.dart';
import '../funcionalidades/ocorrencias/apresentacao/paginas/nova_ocorrencia_pagina.dart';
import '../funcionalidades/ocorrencias/apresentacao/paginas/ocorrencias_pagina.dart';
import '../funcionalidades/ocorrencias/apresentacao/paginas/ocorrencia_detalhe_pagina.dart';
import '../funcionalidades/perfil/apresentacao/paginas/perfil_pagina.dart';
import 'guarda_autenticacao.dart';
import 'rotas_nomes.dart';
import 'shell_navegacao_administrativo.dart';
import 'shell_navegacao_mobile.dart';

final _chaveRaizNavegador = GlobalKey<NavigatorState>(
  debugLabel: 'raiz',
);

GoRouter criarRoteador(Ref ref) {
  return GoRouter(
    navigatorKey: _chaveRaizNavegador,
    initialLocation: RotasNomes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) =>
        guardaAutenticacao(ref, state.matchedLocation),

    routes: [
      // ══════════════════════════════════════════════════════
      // ROTAS PÚBLICAS (sem autenticação)
      // ══════════════════════════════════════════════════════

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

      // ══════════════════════════════════════════════════════
      // ROTAS AVULSAS (autenticadas, fora do shell de abas)
      // Ficam aqui para ter AppBar própria e botão de voltar.
      // ══════════════════════════════════════════════════════

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

      GoRoute(
        path: RotasNomes.historico,
        name: 'historico',
        builder: (context, state) => const HistoricoPagina(),
      ),

      // Nova ocorrência — fica ANTES de /ocorrencias/:id
      // para o GoRouter não confundir "nova" com um ID.
      GoRoute(
        path: RotasNomes.novaOcorrencia,       // '/ocorrencias/nova'
        name: 'nova-ocorrencia',
        builder: (context, state) => const NovaOcorrenciaPagina(),
      ),

      // Detalhe de ocorrência — recebe o id pela URL
      GoRoute(
        path: RotasNomes.detalheOcorrencia,    // '/ocorrencias/:id'
        name: 'detalhe-ocorrencia',
        builder: (context, state) {
          // state.pathParameters['id'] lê o :id da URL automaticamente
          final id = state.pathParameters['id'] ?? '';
          return OcorrenciaDetalhePagina(id: id);
        },
      ),

      // ══════════════════════════════════════════════════════
      // SHELL MOBILE — barra de abas inferior
      // Cada branch é uma aba independente com sua própria pilha
      // ══════════════════════════════════════════════════════

      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            ShellNavegacaoMobile(shell: shell),

        branches: [
          // Aba 0 — Início
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.inicio,       // '/inicio'
                name: 'inicio',
                builder: (context, state) => const InicioPagina(),
              ),
            ],
          ),

          // Aba 1 — Ocorrências
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.ocorrencias,  // '/ocorrencias'
                name: 'ocorrencias',
                builder: (context, state) => const OcorrenciasPagina(),
              ),
            ],
          ),

          // Aba 2 — Mapas
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.mapas,        // '/mapas'
                name: 'mapas',
                builder: (context, state) => const MapasPagina(),
              ),
            ],
          ),

          // Aba 3 — Perfil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.perfil,       // '/perfil'
                name: 'perfil',
                builder: (context, state) => const PerfilPagina(),
              ),
            ],
          ),
        ],
      ),

      // ══════════════════════════════════════════════════════
      // SHELL ADMINISTRATIVO — rail lateral (web/desktop)
      // ══════════════════════════════════════════════════════

      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            ShellNavegacaoAdministrativo(shell: shell),

        branches: [
          // Seção 0 — Painel
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.administrativoPainel,
                name: 'administrativo-painel',
                builder: (context, state) => const AdministrativoPainelPagina(),
              ),
            ],
          ),

          // Seção 1 — Mapa
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.administrativoMapa,
                name: 'administrativo-mapa',
                builder: (context, state) =>
                    const AdministrativoMapaPagina(),
              ),
            ],
          ),

          // Seção 2 — Ocorrências
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

          // Seção 3 — Usuários
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RotasNomes.administrativoUsuarios,
                name: 'administrativo-usuarios',
                builder: (context, state) =>
                    const AdministrativoUsuariosPagina(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
