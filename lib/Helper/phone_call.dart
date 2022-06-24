import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCall extends StatelessWidget {
  PhoneCall({Key? key, required this.number, this.onlyIcon = false})
      : super(key: key);
  String number;
  bool onlyIcon;

  @override
  Widget build(BuildContext context) {
    return onlyIcon == true
        ? IconButton(
            onPressed: () {
              launch("tel://${number}");
            },
            icon: const Icon(Icons.phone_in_talk),
          )
        : TextButton.icon(
            icon: const Icon(Icons.phone_in_talk),
            label: const Text("Phone Call"),
            onPressed: () {
              launch("tel://${number}");
            },
          );
  }
}
