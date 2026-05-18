import 'package:flutter/material.dart';

import 'cores.dart';
import 'espacamentos.dart';
import 'tipografia.dart';

/// Tema claro do aplicativo.
abstract final class TemaClaro {
  static ThemeData obter() {
    const esquema = ColorScheme.light(
      primary: Cores.primaria,
      onPrimary: Colors.white,
      secondary: Cores.secundaria,
      error: Cores.erro,
      surface: Cores.superficie,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: Cores.superficie,
      textTheme: Tipografia.obterTextTheme(escuro: false),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Cores.primaria,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Espacamentos.raioBorda),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Espacamentos.raioBorda),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Espacamentos.md,
          vertical: Espacamentos.sm,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Cores.primaria,
        foregroundColor: Colors.white,
      ),
    );
  }
}
