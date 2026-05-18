import 'package:flutter/material.dart';

/// Botão primário reutilizável.
class BotaoPrimario extends StatelessWidget {
  const BotaoPrimario({
    super.key,
    required this.rotulo,
    required this.aoPressionar,
    this.carregando = false,
    this.expandido = true,
  });

  final String rotulo;
  final VoidCallback? aoPressionar;
  final bool carregando;
  final bool expandido;

  @override
  Widget build(BuildContext context) {
    final botao = FilledButton(
      onPressed: carregando ? null : aoPressionar,
      child: carregando
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(rotulo),
    );

    if (!expandido) return botao;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: botao,
    );
  }
}
