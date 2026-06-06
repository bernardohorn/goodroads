import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ocorrencias_provider.dart';
import '../../../../nucleo/utilitarios/formatador_data.dart';

/// Exibe o detalhe completo de uma ocorrência.
/// Recebe o [id] via parâmetro de rota (/ocorrencias/:id).
class OcorrenciaDetalhePagina extends ConsumerWidget {
  const OcorrenciaDetalhePagina({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(ocorrenciaDetalheProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe')),
      body: estado.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (ocorrencia) {
          if (ocorrencia == null) {
            return const Center(child: Text('Ocorrência não encontrada.'));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                ocorrencia.titulo,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Registrado em ${FormatadorData.formatarComHora(ocorrencia.criadoEm)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(ocorrencia.descricao),
              const SizedBox(height: 16),
              Text(
                'Localização: ${ocorrencia.latitude.toStringAsFixed(5)}, '
                '${ocorrencia.longitude.toStringAsFixed(5)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              if (ocorrencia.imagensUrls.isNotEmpty) ...[
                Text(
                  'Fotos',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ocorrencia.imagensUrls.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ocorrencia.imagensUrls[i],
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}