import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de armazenamento local com SharedPreferences.
abstract interface class ArmazenamentoLocalServico {
  Future<String?> ler(String chave);

  Future<void> salvar(String chave, String valor);

  Future<void> remover(String chave);

  Future<void> limpar();
}

class ArmazenamentoLocalServicoImpl implements ArmazenamentoLocalServico {
  ArmazenamentoLocalServicoImpl(this._preferencias);

  static SharedPreferences? _instanciaCompartilhada;

  static void inicializar(SharedPreferences preferencias) {
    _instanciaCompartilhada = preferencias;
  }

  factory ArmazenamentoLocalServicoImpl.obter() {
    final prefs = _instanciaCompartilhada;
    if (prefs == null) {
      throw StateError(
        'SharedPreferences não inicializado. '
        'Execute InicializacaoApp.executar() antes.',
      );
    }
    return ArmazenamentoLocalServicoImpl(prefs);
  }

  final SharedPreferences _preferencias;

  @override
  Future<String?> ler(String chave) async => _preferencias.getString(chave);

  @override
  Future<void> salvar(String chave, String valor) async {
    await _preferencias.setString(chave, valor);
  }

  @override
  Future<void> remover(String chave) async {
    await _preferencias.remove(chave);
  }

  @override
  Future<void> limpar() async {
    await _preferencias.clear();
  }
}
