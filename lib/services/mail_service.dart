import 'dart:async';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'export_txt.dart';


class MailService{

  Future<void> sendRRExam(String rrExamName) async {

    String path = await ExportTxtService().getDirPath();
    String pj = '$path/$rrExamName.txt';

    final Email email = Email(
      body: 'Envoi de la session RR $rrExamName',
      subject: 'MisMi HRV Exam',
      recipients:['pascalifremmont@gmail.com'],
      cc:['thibautverjux@hotmail.fr'],
      bcc:[],
      isHTML: false,
      attachmentPaths: ['$pj']
    );

    await FlutterEmailSender.send(email);
  }

}