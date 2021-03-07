import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

abstract class IEmailService {
  Future<bool> sendMessage(
      String mensagem, String destinatario, String assunto);
}

class EmailService implements IEmailService {
  String _username = "giliard_sousa@hotmail.com";
  String _password = "gladsous9155";

  var _smtpServer;

  EmailService() {
    _smtpServer = hotmail(_username, _password);
  }
//Envia um email para o destinatário, contendo a mensagem com o nome do sorteado
  @override
  Future<bool> sendMessage(
      String mensagem, String destinatario, String assunto) async {
    //Configurar a mensagem
    final message = Message()
      ..from = Address(_username, 'Alloc')
      ..recipients.add(destinatario)
      ..subject = assunto
      ..text = mensagem;

    try {
      await send(message, _smtpServer);
      return true;
    } on MailerException catch (e) {
      String error = 'Falha ao enviar email.';

      for (var p in e.problems) {
        error += ' Problem: ${p.code}: ${p.msg};';
      }
      LoggerUtil.error(error);
      return false;
    }
  }
}
