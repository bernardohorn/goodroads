import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../ambiente/variaveis_ambiente.dart';
import 'firebase_options.dart';

/// Inicializa o Firebase quando habilitado e configurado.
abstract final class InicializacaoFirebase {
  static Future<void> executar() async {
    if (!VariaveisAmbiente.firebaseHabilitado) {
      debugPrint('[GoodRoads] Firebase desabilitado via ambiente.');
      return;
    }

    if (OpcoesFirebase.saoPlaceholders) {
      debugPrint(
        '[GoodRoads] Firebase habilitado, mas opcoes_firebase.dart '
        'ainda contém placeholders. Execute flutterfire configure.',
      );
      return;
    }

    await Firebase.initializeApp(options: OpcoesFirebase.atuais);
    debugPrint('[GoodRoads] Firebase inicializado.');
  }
}
