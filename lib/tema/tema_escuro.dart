import 'package:flutter/material.dart';

import 'cores.dart';
import 'espacamentos.dart';
import 'tipografia.dart';

/// Tema escuro do aplicativo.
abstract final class TemaEscuro {
  static ThemeData obter() {
    const esquema = ColorScheme.dark(
      primary: Cores.primariaClara,
      onPrimary: Colors.black,
      secondary: Cores.secundaria,
      error: Cores.erro,
      surface: Cores.superficieEscura,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: esquema,
      scaffoldBackgroundColor: Cores.superficieEscura,
      textTheme: Tipografia.obterTextTheme(escuro: true),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Espacamentos.raioBorda),
        ),
      ),
    );
  }
}
