import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Model/meeting_event.dart';

class AllMeetings extends StatelessWidget {
  const AllMeetings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> filter =
        FirebaseFirestore.instance.collection("meeting");

    return Scaffold(
      appBar: AppBar(title: const Text("All Meetings")),
      body: StreamBuilder<QuerySnapshot>(
        stream: filter.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
          List<Meeting> memberlist = data
              .map((e) => Meeting(
                    desc: e['description'],
                    title: e['title'],
                    meetingUrl: e['meetingUrl'],
                    date: DateTime.parse(e['date']),
                    urls: e['imageUrl'].toString().split(','),
                    id: e.id,
                  ))
              .toList();

          if (memberlist.isEmpty) {
            return Center(
              child: Chip(label: const Text("No Meeting")),
            );
          }

          return ListView.builder(
            itemCount: memberlist.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(memberlist[index].title!),
              subtitle: Text(memberlist[index].id!),
              trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    CollectionReference data =
                        FirebaseFirestore.instance.collection("meeting");
                    data.doc(memberlist[index].id).delete();
                    showSnakeBar(
                        context, memberlist[index].title! + " Meeting deleted");
                  }),
            ),
          );
        },
      ),
    );
  }
}
