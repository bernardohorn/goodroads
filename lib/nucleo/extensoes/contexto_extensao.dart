import 'package:flutter/material.dart';

import '../../tema/espacamentos.dart';

extension ContextoExtensao on BuildContext {
  ThemeData get tema => Theme.of(this);

  ColorScheme get cores => tema.colorScheme;

  TextTheme get textos => tema.textTheme;

  MediaQueryData get midia => MediaQuery.of(this);

  Size get tamanhoTela => midia.size;

  bool get ehTelaPequena => tamanhoTela.width < Espacamentos.larguraTablet;

  bool get ehPainelAdministrativo => tamanhoTela.width >= Espacamentos.larguraDesktop;
}
