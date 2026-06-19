import 'usuario_modelo.dart';

/// Resposta padrão dos endpoints de login e registro.
class RespostaAutenticacaoModelo {
  const RespostaAutenticacaoModelo({
    required this.token,
    required this.usuario,
  });

  final String token;
  final UsuarioModelo usuario;

  factory RespostaAutenticacaoModelo.fromJson(Map<String, dynamic> json) {
    return RespostaAutenticacaoModelo(
      token: json['token'] as String,
      usuario: UsuarioModelo.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }
}
