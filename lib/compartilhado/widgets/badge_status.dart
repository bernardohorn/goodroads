import 'package:flutter/material.dart';

import '../../funcionalidades/ocorrencias/dominio/entidades/ocorrencia_entidade.dart';

/// Badge colorido de status de ocorrência.
class BadgeStatus extends StatelessWidget {
  const BadgeStatus({super.key, required this.status});

  final String status;

  static (Color fundo, Color texto, String rotulo) rotuloECores(String status) {
    return switch (status) {
      'pendente' => (Colors.orange.shade100, Colors.orange.shade800, 'Pendente'),
      'em_analise' => (Colors.blue.shade100, Colors.blue.shade800, 'Em análise'),
      'em_andamento' =>
        (Colors.purple.shade100, Colors.purple.shade800, 'Em andamento'),
      'resolvido' => (Colors.green.shade100, Colors.green.shade800, 'Resolvido'),
      'cancelado' => (Colors.grey.shade200, Colors.grey.shade700, 'Cancelado'),
      _ => (Colors.grey.shade200, Colors.grey.shade700, status),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (fundo, corTexto, rotulo) = rotuloECores(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        rotulo,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: corTexto,
        ),
      ),
    );
  }
}

/// Cor do marcador no mapa conforme status.
Color corMarcadorPorStatus(String status) {
  return switch (status) {
    'pendente' => Colors.orange,
    'em_analise' => Colors.blue,
    'em_andamento' => Colors.blue,
    'resolvido' => Colors.green,
    'cancelado' => Colors.grey,
    _ => Colors.orange,
  };
}

/// Cartão resumido de ocorrência para listagens.
class CartaoOcorrenciaResumo extends StatelessWidget {
  const CartaoOcorrenciaResumo({
    super.key,
    required this.ocorrencia,
    this.aoTocar,
  });

  final OcorrenciaEntidade ocorrencia;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ocorrencia.titulo,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  BadgeStatus(status: ocorrencia.status),
                ],
              ),
              if (ocorrencia.protocolo != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Protocolo: ${ocorrencia.protocolo}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 6),
              Text(
                ocorrencia.descricao,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ocorrencia.municipio ??
                          '${ocorrencia.latitude.toStringAsFixed(4)}, '
                              '${ocorrencia.longitude.toStringAsFixed(4)}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (ocorrencia.imagensUrls.isNotEmpty) ...[
                    const Icon(Icons.photo_outlined, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${ocorrencia.imagensUrls.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
