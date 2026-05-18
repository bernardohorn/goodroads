/// Contrato base para cliente HTTP (implementação futura com API).
abstract interface class ClienteHttp {
  Future<Map<String, dynamic>> get(String caminho);

  Future<Map<String, dynamic>> post(
    String caminho, {
    Map<String, dynamic>? corpo,
  });

  Future<Map<String, dynamic>> put(
    String caminho, {
    Map<String, dynamic>? corpo,
  });

  Future<void> delete(String caminho);
}
