import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../configuracao/firebase/inicializacao_firebase.dart';
import '../../../../nucleo/erros/falha.dart';

/// Fonte de autenticação via Firebase Auth.
abstract interface class AutenticacaoFirebaseFonte {
  bool get disponivel;

  /// Retorna `null` em sucesso ou uma [Falha] em erro.
  Future<Falha?> registrar({
    required String email,
    required String senha,
  });

  /// Retorna `null` em sucesso ou uma [Falha] em erro.
  Future<Falha?> entrar({
    required String email,
    required String senha,
  });
}

class AutenticacaoFirebaseFonteImpl implements AutenticacaoFirebaseFonte {
  @override
  bool get disponivel => firebaseInicializado;

  @override
  Future<Falha?> registrar({
    required String email,
    required String senha,
  }) async {
    if (!disponivel) return null;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: senha,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('[GoodRoads] Firebase Auth registro: ${e.code}');
      return _mapearErroFirebase(e);
    } catch (e) {
      debugPrint('[GoodRoads] Firebase Auth registro inesperado: $e');
      return const FalhaDesconhecida();
    }
  }

  @override
  Future<Falha?> entrar({
    required String email,
    required String senha,
  }) async {
    if (!disponivel) return null;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: senha,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('[GoodRoads] Firebase Auth login: ${e.code}');
      return _mapearErroFirebase(e);
    } catch (e) {
      debugPrint('[GoodRoads] Firebase Auth login inesperado: $e');
      return const FalhaDesconhecida();
    }
  }

  Falha _mapearErroFirebase(FirebaseAuthException e) {
    return switch (e.code) {
      'email-already-in-use' => const FalhaEmailJaCadastrado(),
      'invalid-email' => const FalhaEmailInvalido(),
      'weak-password' => const FalhaSenhaFraca(),
      'wrong-password' || 'invalid-credential' || 'user-not-found' =>
        const FalhaAutenticacao(),
      'network-request-failed' => const FalhaRede(),
      'too-many-requests' =>
        const FalhaDesconhecida('Muitas tentativas. Aguarde e tente novamente.'),
      _ => FalhaDesconhecida(
          e.message ?? 'Erro de autenticação. Tente novamente.',
        ),
    };
  }
}
