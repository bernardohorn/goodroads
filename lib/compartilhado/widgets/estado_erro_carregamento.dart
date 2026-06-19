import 'package:flutter/material.dart';

import '../../nucleo/utilitarios/extrator_mensagem_erro.dart';
import '../../tema/cores.dart';

/// Widget padrão para estado de erro com botão "Tentar novamente".
class EstadoErroCarregamento extends StatelessWidget {
  const EstadoErroCarregamento({
    super.key,
    required this.erro,
    required this.aoTentarNovamente,
    this.titulo = 'Não foi possível carregar os dados',
  });

  final Object erro;
  final VoidCallback aoTentarNovamente;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Cores.textoSecundario),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              extrairMensagemErro(erro),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Cores.textoSecundario,
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: aoTentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
