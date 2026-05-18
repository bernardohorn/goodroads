/// Contrato do serviço de notificações push (FCM — implementação futura).
abstract interface class NotificacaoServico {
  Future<void> inicializar();

  Future<void> solicitarPermissao();

  Future<String?> obterTokenDispositivo();
}
