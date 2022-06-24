import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress2/Screen/in_app_web_view.dart';
import 'package:progress2/control.dart';

class DrawerTile extends StatelessWidget {
  Map<String, String> control;
  DrawerTile({Key? key, required this.control}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const FaIcon(FontAwesomeIcons.osi),
      title: Text(control['title']!),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InAppWebViewExampleScreen(control: control),
          ),
        );
      },
    );
  }
}
