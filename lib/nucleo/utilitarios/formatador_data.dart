import 'package:intl/intl.dart';

/// Formata datas para exibição na interface.
abstract final class FormatadorData {
  static final DateFormat _padrao = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final DateFormat _comHora = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

  static String formatar(DateTime data) => _padrao.format(data);

  static String formatarComHora(DateTime data) => _comHora.format(data);
}
