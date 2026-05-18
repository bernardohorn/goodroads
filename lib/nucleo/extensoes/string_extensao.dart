extension StringExtensao on String {
  bool get estaVazioOuNulo => trim().isEmpty;

  String get capitalizado {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
