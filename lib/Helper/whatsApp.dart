import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppContact extends StatelessWidget {
  WhatsAppContact({Key? key, required this.number, this.onlyIcon = false})
      : super(key: key);
  String number;
  bool onlyIcon;
  @override
  Widget build(BuildContext context) {
    TextEditingController? _query = TextEditingController(text: "");
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Container(
      // padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: onlyIcon == true
            ? IconButton(
                onPressed: () {
                  openwhatsapp(context, "Hi, ", number);
                },
                icon: Icon(Icons.maps_ugc_sharp),
              )
            : TextButton.icon(
                onPressed: () {
                  openwhatsapp(context, "Hi, ", number);
                },
                icon: Icon(Icons.maps_ugc_sharp),
                label: Text(
                  "Send Message",
                  style: TextStyle(color: Colors.green),
                ),
              ),
      ),
    );
  }
}

openEmail(BuildContext context, String text) {
  // String msg =
  //     "http//www.mailto:${Uri.encodeFull('anmolshah.20k@gmail.com')}?subject=${Uri.encodeFull('Subject')} Title&body=${Uri.encodeFull(text)}";
  // print(msg);
  final Uri params = Uri(
      scheme: 'mailto',
      path: 'anmolshah.20k@gmail.com',
      query:
          "{subject=${Uri.encodeFull('Subject')} Title&body=${Uri.encodeFull(text)}");
  try {
    var url = params.toString();
    print(url);
    launch(url);
  } catch (e) {
    showSnakeBar(context, e.toString());
  }
}

openwhatsapp(BuildContext context, String text, String number) async {
  try {
    String msg = text;
    var whatsapp = "+91$number";
    var whatsappURlAndroid =
        "https://whatsapp://send?phone=" + whatsapp + "&text=$msg";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse(msg)}";
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
        showSnakeBar(context, "Thanks");
      } else {
        showSnakeBar(context, "Whatsapp Not Installed");
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatappURLIos);
        showSnakeBar(context, "Thanks");
      } else if (defaultTargetPlatform != TargetPlatform.android) {
        // await launch(whatsappURlAndroid);
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        showSnakeBar(context, "Whatsapp Not Installed");
      }
    }
  } catch (e) {
    showSnakeBar(context, e.toString());
  }
}
