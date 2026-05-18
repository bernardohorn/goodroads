import 'package:flutter/material.dart';

/// Widget base para páginas em construção.
class PaginaPlaceholder extends StatelessWidget {
  const PaginaPlaceholder({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.icone = Icons.construction_outlined,
  });

  final String titulo;
  final String? subtitulo;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitulo!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
