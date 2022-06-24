import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Model/blog_event.dart';
import 'package:progress2/Widget/title_widget.dart';

class BlogsRead extends StatelessWidget {
  const BlogsRead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginDetailStream =
        FirebaseFirestore.instance.collection("blog").snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: loginDetailStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        List<Blog> data = snapshot.data!.docs
            .map(
              (e) => Blog(
                id: e.id,
                text: e['text'],
                title: e['title'],
                date: DateTime.parse(e['date']),
                urls: e['imageUrl'].toString().split(','),
                by: e['by'],
              ),
            )
            .toList();

        // return Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     const TitleWidget(text: "Latest Blogs"),
        //     CarouselSlider(
        //       items: data.map((e) {
        //         return e.build();
        //       }).toList(),
        //       options: CarouselOptions(
        //         height: 300,
        //         initialPage: 0,
        //         enableInfiniteScroll: true,
        //         reverse: true,
        //         autoPlay: false,
        //         autoPlayInterval: const Duration(seconds: 5),
        //         autoPlayAnimationDuration: const Duration(milliseconds: 800),
        //         autoPlayCurve: Curves.fastOutSlowIn,
        //         enlargeCenterPage: false,
        //         scrollDirection: Axis.horizontal,
        //         viewportFraction: 1,
        //       ),
        //     ),
        //   ],
        // );

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => data[index].build(),
        );
      },
    );
  }
}
