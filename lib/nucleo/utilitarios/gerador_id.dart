import 'package:uuid/uuid.dart';

/// Gera identificadores únicos para entidades.
abstract final class GeradorId {
  static const _uuid = Uuid();

  static String novo() => _uuid.v4();
}
