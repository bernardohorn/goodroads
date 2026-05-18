import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'nucleo/constantes/constantes_aplicativo.dart';
import 'nucleo/injecao_dependencias/provedores_globais.dart';
import 'tema/tema_aplicativo.dart';

/// Widget raiz do aplicativo GoodRoads.
class AplicativoGoodRoads extends ConsumerWidget {
  const AplicativoGoodRoads({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roteador = ref.watch(roteadorProvider);

    return MaterialApp.router(
      title: ConstantesAplicativo.nomeAplicativo,
      debugShowCheckedModeBanner: false,
      theme: TemaAplicativo.claro,
      darkTheme: TemaAplicativo.escuro,
      themeMode: ThemeMode.light,
      routerConfig: roteador,
    );
  }
}
