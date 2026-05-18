import 'package:flutter/material.dart';

import 'cores.dart';

/// Estilos de texto padronizados.
abstract final class Tipografia {
  static TextTheme obterTextTheme({required bool escuro}) {
    final cor = escuro ? Colors.white : Cores.textoPrimario;
    return TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: cor,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: cor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: cor,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: cor),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: escuro ? Colors.white70 : Cores.textoSecundario,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: cor,
      ),
    );
  }
}
