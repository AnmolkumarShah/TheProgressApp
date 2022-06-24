import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress2/Helper/date_formate.dart';
import 'package:progress2/Helper/loader_helper.dart';

class ReadBlogScreen extends StatelessWidget {
  String? id;
  ReadBlogScreen({Key? key, this.id}) : super(key: key);
  final TextStyle _title = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  final TextStyle _date = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );

  final TextStyle _text = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance.collection('blog');

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: collection.doc(id).get(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            Map<String, dynamic>? data = snapshot.data!.data();
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(8.0),
                      child: CarouselSlider(
                        items:
                            data!['imageUrl']!.toString().split(",").map((e) {
                          return SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                e,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: double.infinity,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 10),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          // onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 1,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'],
                            style: _title,
                          ),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.globe,
                                color: Colors.white,
                                size: 10,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                format(DateTime.parse(data['date'])),
                                style: _date,
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white),
                          Text(
                            data['text'],
                            style: _text,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Loader();
        },
      ),
    );
  }
}
