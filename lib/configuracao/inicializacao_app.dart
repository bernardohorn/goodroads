import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../servicos/armazenamento_local_servico.dart';
import 'ambiente/variaveis_ambiente.dart';
import 'firebase/inicializacao_firebase.dart';

/// Orquestra a inicialização de serviços globais do aplicativo.
abstract final class InicializacaoApp {
  static SharedPreferences? preferencias;

  static Future<void> executar() async {
    await VariaveisAmbiente.carregar();
    await initializeDateFormatting('pt_BR');
    preferencias = await SharedPreferences.getInstance();
    ArmazenamentoLocalServicoImpl.inicializar(preferencias!);
    await InicializacaoFirebase.executar();
    debugPrint('[GoodRoads] Ambiente inicializado.');
  }
}
