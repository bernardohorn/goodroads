import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../funcionalidades/autenticacao/apresentacao/providers/autenticacao_provider.dart';
import '../../nucleo/erros/falha.dart';
import '../../nucleo/utilitarios/extrator_mensagem_erro.dart';
import '../../rotas/rotas_nomes.dart';
import '../../tema/cores.dart';

/// Widget padrão para estado de erro com botão "Tentar novamente".
class EstadoErroCarregamento extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final ehTokenExpirado = erro is FalhaTokenExpirado;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ehTokenExpirado ? Icons.lock_clock : Icons.wifi_off,
              size: 48,
              color: Cores.textoSecundario,
            ),
            const SizedBox(height: 12),
            Text(
              ehTokenExpirado ? 'Sessão expirada' : titulo,
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
            if (ehTokenExpirado)
              FilledButton.icon(
                onPressed: () async {
                  await ref.read(autenticacaoControladorProvider.notifier).sair();
                  if (context.mounted) {
                    await Navigator.of(context).pushNamedAndRemoveUntil(RotasNomes.login, (route) => false);
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text('Fazer login novamente'),
              )
            else
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
