import 'package:flutter/material.dart';

import 'tema_claro.dart';
import 'tema_escuro.dart';

/// Ponto central de acesso aos temas do GoodRoads.
abstract final class TemaAplicativo {
  static ThemeData get claro => TemaClaro.obter();

  static ThemeData get escuro => TemaEscuro.obter();
}
