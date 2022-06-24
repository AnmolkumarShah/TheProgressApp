import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress2/Helper/date_formate.dart';
import 'package:progress2/Helper/show_slider_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'event.dart';

class Meeting extends Event {
  String? title;
  String? desc;
  String? meetingUrl;
  List<String>? urls;
  DateTime? date;
  String? by;
  String? id;

  Meeting(
      {this.date, this.desc, this.title, this.urls, this.meetingUrl, this.by,this.id});

  Future<bool> save() async {
    CollectionReference data = FirebaseFirestore.instance.collection("meeting");
    String imageUrl = urls!.join(",");
    try {
      final result = await data.add({
        'title': title,
        'date': date!.toIso8601String(),
        'description': desc,
        'imageUrl': imageUrl,
        'meetingUrl': meetingUrl,
        'by': by,
      });
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<void> _launchInBrowser() async {
    if (!await launch(
      meetingUrl!,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $meetingUrl';
    }
  }

  @override
  Widget build() {
    return MeetingBuild(m: this);
  }
}

class MeetingBuild extends StatelessWidget {
  MeetingBuild({Key? key, required this.m}) : super(key: key);
  Meeting m;

  @override
  Widget build(BuildContext context) {
    TextStyle _titleStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    TextStyle _dateStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DottedBorder(
        padding: const EdgeInsets.all(5),
        radius: const Radius.circular(20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ShowSliderFromUrl(m.urls!),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.title!,
                          style: _titleStyle,
                        ),
                        const SizedBox(height: 10),
                        Text(format(m.date!), style: _dateStyle),
                        // Wrap(children: [Text(m.desc!)]),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        m._launchInBrowser();
                      },
                      icon: const FaIcon(FontAwesomeIcons.handshake),
                      label: const Text("Join Meet"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
