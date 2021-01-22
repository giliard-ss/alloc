abstract class IEmailService {
  Future<bool> sendMessage(
      String mensagem, String destinatario, String assunto);
}
