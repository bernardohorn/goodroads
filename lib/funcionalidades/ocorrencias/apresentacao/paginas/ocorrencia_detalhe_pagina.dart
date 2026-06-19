import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../compartilhado/widgets/imagem_rede.dart';
import '../../../../nucleo/utilitarios/formatador_data.dart';
import '../../../autenticacao/apresentacao/providers/autenticacao_provider.dart';
import '../providers/ocorrencias_provider.dart';
import '../../dominio/entidades/ocorrencia_entidade.dart';

/// Etapas visuais da linha do tempo.
/// **Decisão de design:** `em_analise` é exibido como etapa própria entre
/// Pendente e Em andamento, refletindo o fluxo real do backend.
const _etapasVisuais = [
  ('pendente', 'Pendente'),
  ('em_analise', 'Em análise'),
  ('em_andamento', 'Em andamento'),
  ('resolvido', 'Resolvido'),
];

/// Exibe o detalhe completo de uma ocorrência.
class OcorrenciaDetalhePagina extends ConsumerWidget {
  const OcorrenciaDetalhePagina({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(ocorrenciaDetalheProvider(id));
    final ehAdmin =
        usuarioEhAdmin(ref.watch(autenticacaoControladorProvider).valueOrNull);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe da ocorrência')),
      body: estado.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EstadoErroCarregamento(
          erro: e,
          aoTentarNovamente: () => ref.refresh(ocorrenciaDetalheProvider(id)),
        ),
        data: (ocorrencia) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ocorrencia.titulo,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                BadgeStatus(status: ocorrencia.status),
              ],
            ),
            if (ocorrencia.protocolo != null) ...[
              const SizedBox(height: 4),
              Text('Protocolo: ${ocorrencia.protocolo}'),
            ],
            const SizedBox(height: 8),
            Text(
              'Registrado em ${FormatadorData.formatarComHora(ocorrencia.criadoEm)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text('Descrição', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(ocorrencia.descricao),
            const SizedBox(height: 16),
            if (ocorrencia.imagensUrls.isNotEmpty) ...[
              Text('Fotos', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ocorrencia.imagensUrls.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImagemRede(
                      url: ocorrencia.imagensUrls[i],
                      largura: 120,
                      altura: 120,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text('Localização', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (ocorrencia.municipio != null)
              Text(ocorrencia.municipio!),
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      ocorrencia.latitude,
                      ocorrencia.longitude,
                    ),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(ocorrencia.id),
                      position: LatLng(
                        ocorrencia.latitude,
                        ocorrencia.longitude,
                      ),
                    ),
                  },
                  zoomControlsEnabled: false,
                  scrollGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (ehAdmin) ...[
              Text(
                'Emitir status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _PainelAdminStatus(ocorrencia: ocorrencia),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Classificação interna (categoria, prioridade, atribuído a) '
                  'requer migration no banco — campos não existem em banco.sql.',
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              'Linha do tempo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _LinhaDoTempo(
              statusAtual: ocorrencia.status,
              historico: ocorrencia.historico,
              criadoEm: ocorrencia.criadoEm,
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaDoTempo extends StatelessWidget {
  const _LinhaDoTempo({
    required this.statusAtual,
    required this.historico,
    required this.criadoEm,
  });

  final String statusAtual;
  final List<HistoricoStatusEntidade> historico;
  final DateTime criadoEm;

  @override
  Widget build(BuildContext context) {
    final indiceAtual = _etapasVisuais.indexWhere((e) => e.$1 == statusAtual);

    return Column(
      children: [
        ..._etapasVisuais.asMap().entries.map((entrada) {
          final indice = entrada.key;
          final (codigo, rotulo) = entrada.value;
          final concluido = indice <= indiceAtual && indiceAtual >= 0;
          final atual = codigo == statusAtual;

          final eventos = historico
              .where((h) => h.status == codigo)
              .toList();

          return _EtapaTimeline(
            rotulo: rotulo,
            concluido: concluido,
            atual: atual,
            eventos: eventos,
            criadoEm: indice == 0 ? criadoEm : null,
          );
        }),
      ],
    );
  }
}

class _EtapaTimeline extends StatelessWidget {
  const _EtapaTimeline({
    required this.rotulo,
    required this.concluido,
    required this.atual,
    required this.eventos,
    this.criadoEm,
  });

  final String rotulo;
  final bool concluido;
  final bool atual;
  final List<HistoricoStatusEntidade> eventos;
  final DateTime? criadoEm;

  @override
  Widget build(BuildContext context) {
    final cor = concluido
        ? (atual ? Theme.of(context).colorScheme.primary : Colors.green)
        : Colors.grey.shade400;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              concluido ? Icons.check_circle : Icons.radio_button_unchecked,
              color: cor,
              size: 22,
            ),
            Container(width: 2, height: 40, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              rotulo,
              style: TextStyle(
                fontWeight: atual ? FontWeight.bold : FontWeight.normal,
                color: concluido ? null : Colors.grey,
              ),
            ),
            subtitle: criadoEm != null && eventos.isEmpty
                ? Text(FormatadorData.formatarComHora(criadoEm!))
                : null,
            children: eventos.isEmpty
                ? [
                    if (criadoEm != null)
                      ListTile(
                        dense: true,
                        title: Text(
                          FormatadorData.formatarComHora(criadoEm!),
                        ),
                      ),
                  ]
                : eventos
                    .map(
                      (h) => ListTile(
                        dense: true,
                        title: Text(
                          FormatadorData.formatarComHora(h.dataAlteracao),
                        ),
                        subtitle: h.observacao != null
                            ? Text(h.observacao!)
                            : h.responsavel != null
                                ? Text('Por: ${h.responsavel}')
                                : null,
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class _PainelAdminStatus extends ConsumerWidget {
  const _PainelAdminStatus({required this.ocorrencia});

  final OcorrenciaEntidade ocorrencia;

  static const _opcoes = [
    ('pendente', 'Pendente'),
    ('em_analise', 'Em análise'),
    ('em_andamento', 'Em andamento'),
    ('resolvido', 'Resolvida'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(atualizarStatusProvider(ocorrencia.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          key: ValueKey(ocorrencia.status),
          initialValue: ocorrencia.status,
          decoration: InputDecoration(
            labelText: 'Status',
            suffix: estado.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          items: _opcoes
              .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
              .toList(),
          onChanged: (novo) {
            if (novo != null && novo != ocorrencia.status) {
              ref
                  .read(atualizarStatusProvider(ocorrencia.id).notifier)
                  .atualizar(novoStatus: novo);
            }
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _opcoes.map((o) {
            return OutlinedButton(
              onPressed: () => ref
                  .read(atualizarStatusProvider(ocorrencia.id).notifier)
                  .atualizar(novoStatus: o.$1),
              child: Text(o.$2),
            );
          }).toList(),
        ),
      ],
    );
  }
}
