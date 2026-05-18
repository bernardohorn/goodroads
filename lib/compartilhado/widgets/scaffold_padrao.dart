import 'package:flutter/material.dart';

/// Scaffold padronizado com AppBar opcional.
class ScaffoldPadrao extends StatelessWidget {
  const ScaffoldPadrao({
    super.key,
    required this.titulo,
    required this.corpo,
    this.acoes,
    this.botaoFlutuante,
  });

  final String titulo;
  final Widget corpo;
  final List<Widget>? acoes;
  final Widget? botaoFlutuante;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: acoes,
      ),
      body: corpo,
      floatingActionButton: botaoFlutuante,
    );
  }
}
