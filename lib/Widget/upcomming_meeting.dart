import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Model/meeting_event.dart';

import 'title_widget.dart';

class UpcommingMeeting extends StatelessWidget {
  const UpcommingMeeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> loginDetailStream =
        FirebaseFirestore.instance.collection("meeting").snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: loginDetailStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        List<Meeting> data = snapshot.data!.docs
            .map(
              (e) => Meeting(
                desc: e['description'],
                title: e['title'],
                meetingUrl: e['meetingUrl'],
                date: DateTime.parse(e['date']),
                urls: e['imageUrl'].toString().split(','),
              ),
            )
            .toList();
        // return Column(
        //   children: [
        //     const TitleWidget(text: "Upcoming Events"),
        //     CarouselSlider(
        //       items: data.map((e) {
        //         return e.build();
        //       }).toList(),
        //       options: CarouselOptions(
        //         height: 300,
        //         initialPage: 0,
        //         enableInfiniteScroll: true,
        //         reverse: false,
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
