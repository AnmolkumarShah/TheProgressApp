import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

allUserFromDB() async {
  List<Map<String, dynamic>> email = [];
  QuerySnapshot<Map<String, dynamic>> allUsers =
      await FirebaseFirestore.instance.collection("members").get();
  allUsers.docs.forEach((element) {
    print(element.data());
    email.add(element.data());
  });

  return email;
}

sendEmail(String name, String email, String subject, String message) async {
  final serviceId = "service_7k3fp9j";
  final tempateId = "template_k479x4p";
  final userId = "CJo8fgC7FWojSao9d";

  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

  final response = await http.post(
    url,
    headers: {
      'Content-Type': "application/json",
    },
    body: json.encode({
      "service_id": serviceId,
      "template_id": tempateId,
      "user_id": userId,
      "accessToken": "85YTB_MeufSE634QKTEtd",
      "template_params": {
        "user_name": name,
        "user_email": email,
        "user_subject": subject,
        "user_message": message,
      }
    }),
  );

  print(response.body);
}

sendNotification(String link, String meg) async {
  List<Map<String, dynamic>> email_list = await allUserFromDB();
  for (int i = 0; i < email_list.length; i++) {
    await sendEmail(
        email_list[i]['fullname'],
        email_list[i]['email'],
        "A New Meeting Added, Please Join On Time",
        "The meet is on topic ${meg}, Please Join the Meet : ${link}");
  }
}
