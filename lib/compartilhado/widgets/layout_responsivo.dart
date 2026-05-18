import 'package:flutter/material.dart';

import '../../nucleo/extensoes/contexto_extensao.dart';
import '../../tema/espacamentos.dart';

/// Adapta o layout entre mobile, tablet e painel administrativo.
class LayoutResponsivo extends StatelessWidget {
  const LayoutResponsivo({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    final largura = context.tamanhoTela.width;

    if (largura >= Espacamentos.larguraDesktop && desktop != null) {
      return desktop!;
    }

    if (largura >= Espacamentos.larguraTablet && tablet != null) {
      return tablet!;
    }

    return mobile;
  }
}
