/// Entidade de notificação.
class NotificacaoEntidade {
  const NotificacaoEntidade({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.lida,
    required this.criadoEm,
  });

  final String id;
  final String titulo;
  final String mensagem;
  final bool lida;
  final DateTime criadoEm;
}
