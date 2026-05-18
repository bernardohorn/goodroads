import 'package:flutter/material.dart';

/// Indicador de carregamento centralizado.
class IndicadorCarregamento extends StatelessWidget {
  const IndicadorCarregamento({super.key, this.mensagem});

  final String? mensagem;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (mensagem != null) ...[
            const SizedBox(height: 16),
            Text(mensagem!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
