/// Serviço de armazenamento local (SharedPreferences / Hive — implementação futura).
abstract interface class ArmazenamentoLocalServico {
  Future<String?> ler(String chave);

  Future<void> salvar(String chave, String valor);

  Future<void> remover(String chave);

  Future<void> limpar();
}

class ArmazenamentoLocalServicoImpl implements ArmazenamentoLocalServico {
  final Map<String, String> _cache = {};

  @override
  Future<String?> ler(String chave) async => _cache[chave];

  @override
  Future<void> salvar(String chave, String valor) async {
    _cache[chave] = valor;
  }

  @override
  Future<void> remover(String chave) async {
    _cache.remove(chave);
  }

  @override
  Future<void> limpar() async {
    _cache.clear();
  }
}
