import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress2/Helper/date_formate.dart';
import 'package:progress2/Helper/show_slider_url.dart';
import 'package:progress2/Model/event.dart';
import 'package:progress2/Screen/read_blog_screen.dart';

class Blog implements Event {
  String? id;
  String? title;
  String? text;
  List<String>? urls;
  DateTime? date;
  String? by;

  Blog({this.date, this.text, this.title, this.urls, this.id, this.by});

  Future<bool> save() async {
    CollectionReference data = FirebaseFirestore.instance.collection("blog");
    String imageUrl = urls!.join(",");
    try {
      final result = await data.add({
        'title': title,
        'date': date!.toIso8601String(),
        'text': text,
        'imageUrl': imageUrl,
        'by': by,
      });
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  @override
  Widget build() {
    return BlogBuild(m: this);
  }
}

class BlogBuild extends StatelessWidget {
  BlogBuild({Key? key, required this.m}) : super(key: key);
  Blog m;

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
      height: 300,
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
              child: ShowSliderFromUrl(m.urls!, scrollDirection: Axis.vertical),
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
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        Text(format(m.date!), style: _dateStyle),
                        const Divider(color: Colors.black),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                m.text!.length > 100
                                    ? m.text!.substring(0, 100)
                                    : m.text!,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadBlogScreen(id: m.id),
                          ),
                        );
                      },
                      icon: const FaIcon(FontAwesomeIcons.readme),
                      label: const Text("Read More"),
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
