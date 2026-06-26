import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../ambiente/variaveis_ambiente.dart';
import 'firebase_options.dart';

/// Indica se o Firebase foi inicializado nesta sessão.
bool firebaseInicializado = false;

/// Inicializa o Firebase quando habilitado e configurado.
abstract final class InicializacaoFirebase {
  static Future<void> executar() async {
    if (!VariaveisAmbiente.firebaseHabilitado) {
      debugPrint(
        '[GoodRoads] Firebase desabilitado via ambiente.\n'
        '           → Para ativar: adicione FIREBASE_HABILITADO=true ao .env\n'
        '           → Preencha FIREBASE_API_KEY, FIREBASE_PROJECT_ID, etc.\n'
        '           → Ou execute: dart run flutterfire_cli:flutterfire configure',
      );
      return;
    }

    if (OpcoesFirebase.saoPlaceholders) {
      debugPrint(
        '[GoodRoads] Firebase habilitado, mas credenciais não configuradas.\n'
        '           → Preencha as variáveis FIREBASE_* no .env (veja .env.example)\n'
        '           → Ou execute: dart run flutterfire_cli:flutterfire configure\n'
        '           → Android: coloque google-services.json em android/app/',
      );
      return;
    }

    try {
      await Firebase.initializeApp(options: OpcoesFirebase.atuais);
      firebaseInicializado = true;
      debugPrint(
        '[GoodRoads] Firebase inicializado com sucesso.\n'
        '           → Projeto: ${OpcoesFirebase.atuais.projectId}',
      );
    } catch (e) {
      firebaseInicializado = false;
      debugPrint('[GoodRoads] Falha ao inicializar Firebase: $e');
    }
  }
}
