import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Model/blog_event.dart';

class AllBlogs extends StatelessWidget {
  const AllBlogs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> filter =
        FirebaseFirestore.instance.collection("blog");

    return Scaffold(
      appBar: AppBar(title: const Text("All Blogs")),
      body: StreamBuilder<QuerySnapshot>(
        stream: filter.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
          List<Blog> memberlist = data
              .map((e) => Blog(
                    id: e.id,
                    text: e['text'],
                    title: e['title'],
                    date: DateTime.parse(e['date']),
                    urls: e['imageUrl'].toString().split(','),
                    by: e['by'],
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
                        FirebaseFirestore.instance.collection("blog");
                    data.doc(memberlist[index].id).delete();
                    showSnakeBar(
                        context, memberlist[index].title! + " blog deleted");
                  }),
            ),
          );
        },
      ),
    );
  }
}
